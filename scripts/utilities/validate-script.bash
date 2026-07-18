#!/usr/bin/env bash

name="$1"

echo "Validating $name ..."

bash -n "$name"
code=$?

if ((code != 0)); then
  echo "Script failed syntax validation"
  exit 1
fi

shellcheck_bin=$(which shellcheck)
if [[ ! -x "$shellcheck_bin" ]]; then
  echo "shellcheck command is required!"
  echo "It either is not installed or cannot be executed"
  exit 1
fi

"$shellcheck_bin" "$name"
code=$?

if ((code != 0)); then
  echo "Script failed shellcheck validation"
  exit 1
fi

echo "No issues found"
