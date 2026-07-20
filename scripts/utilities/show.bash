#!/usr/bin/env bash

file="$1"
if [[ ! -r "$file" ]] || [[ ! -x "$file" ]]; then
  echo "Provided file does not exist, cannot be read or executed. Exiting"
  exit 1
fi

find_cat_like_bin() {
  bat_bin=$(which "$1" 2>/dev/null)
  code="$?"
  if ((code != 0)); then
    return 1
  fi
  echo "$bat_bin"
}

declare -a cat_like_bins
cat_like_bins=(
  "$(find_cat_like_bin "cat")"
  "$(find_cat_like_bin "batcat")"
  "$(find_cat_like_bin "bat")"
)

if (("${#cat_like_bins}" == 0)); then
  echo "Could not find suitable cat like program. What kind of system are you running?"
  exit 1
fi

cat_bin="${cat_like_bins[-1]}"

echo
"$cat_bin" "$file"
source "$file"
echo
