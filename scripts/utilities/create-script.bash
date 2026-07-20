#!/usr/bin/env bash

increment=1
template_file=""
chunk_size=4096
bash_extension=0
number_prefix_override=""

validate_numeric_arg() {
  printf -v leftover "%s" "${1//[[:digit:]]/}"
  if [[ -n "$leftover" ]]; then
    echo "Invalid number was passed as an argument to $2"
    exit 1
  fi
}

while getopts 'bc:hin:t:' flag; do
  case "$flag" in
    b)
      bash_extension=1
    ;;
    c)
      chunk_size="$OPTARG"
      validate_numeric_arg "$chunk_size" "-c"
    ;;
    h)
      echo -e "Utility script for creating bash scripts\n"
      echo "-b"
      echo -e "\tWill create the script with the bash file extention\n"
      echo "-c bytes"
      echo -e "\tSets the chunk size in bytes (chars). Defaults to 4096\n"
      echo "-h"
      echo -e "\tDisplays this help message\n"
      echo "-i"
      echo -e "\tDisables automatically adding a script number to the beginning of the script name. Example: 01-script\n"
      echo "-n number"
      echo -e "\tOverrides the prefix number. Will be ignored if -i is set\n"
      echo "-t template"
      echo -e "\tPath to the desired script template. Creates a blank file if omitted\n"
      echo -e "Exmaple"
      echo -e "\tcreate-script [-t template] [-ib] [-n number] [-c bytes] name"
      exit 0
    ;;
    i)
      increment=0
    ;;
    n)
      number_prefix_override="$OPTARG"
      validate_numeric_arg "$number_prefix_override" "-n"
    ;;
    t)
      template_file="$OPTARG"
    ;;
    ?)
      echo "create-script -t <template> [-i]"
    ;;
  esac
done

shift "$((OPTIND - 1))"

if [[ -z "$1" ]]; then
  echo "Script name is required. Exiting"
  exit 1
fi

if [[ -n "$template_file" ]] && [[ ! -r "$template_file" ]]; then
  echo "Template file does not exist or cannot be read. Exiting"
  exit 1
fi

max_integer() {
  printf '10#%s\n' "$@" | sort -n | tail -1
}

prefix_name_with_script_count() {
  declare -a found_files
  local files
  files=$(find "$PWD" -mindepth 1 -maxdepth 1 -type f)

  for file in $files; do
    local file_name
    file_name=$(basename "$file")

    if [[ "$file_name" =~ ^[0-9]+ ]]; then
      found_files+=("${file_name:0:2}")
    fi
  done

  local max
  printf -v max "%02d" $(($(max_integer "${found_files[@]}") + 1))
  echo "$max-$1"
}

if ((increment == 1)) && [[ -n "$number_prefix_override" ]]; then
  name="$number_prefix_override-$1"
elif ((increment == 1)); then
  name=$(prefix_name_with_script_count "$1")
else
  name="$1"
fi

if ((bash_extension == 1)); then
  name="$name.bash"
fi

if [[ -r "$name" ]]; then
  echo "A script with the same name already exists. Exiting"
  exit 1
fi

touch "$name"
chmod u+x "$name"

# Copies input to the provided file name (first argument)
# 
# Really could have used cp here but where is the fun in that??
transfer_template() {
  while true; do
    local chunk

    IFS='' read -d '\n' -n "$chunk_size" -r chunk
    local code=$?
    local bytes="${#chunk}"

    if ((bytes != chunk_size)); then
      printf "%s\n" "$chunk" >> "$name"
    else 
      printf "%s" "$chunk" >> "$name"
    fi

    if ((code != 0)); then
      break
    fi
  done
}

if [[ -n "$template_file" ]]; then
  transfer_template < "$template_file"
fi

echo "Created file $name"
