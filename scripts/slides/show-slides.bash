#!/usr/bin/env bash

ESC="\x1b"

cols=$(tput cols)
rows=$(tput lines)
line_colour=40

set_colour() {
  local colour
  colour="$1"
  [[ -z "$colour" ]] && colour=39
  echo -n -e "$ESC[38;5;${colour}m"
}

reset() {
  echo -n -e "$ESC[0m"
}

style_line() {
  local line
  line="$1"
  if [[ "$line" =~ ^\# ]]; then
    printf "$(set_colour 165)%s\n" "$line"
    reset
    return 0
  fi
  
  printf "%s\n" "$line"
}

readonly lc="\\u2014"
draw_line() {
  local line middle leftover digits
  middle=$(((cols/2)))
  digits="${#2}"
  leftover=$(((cols % 2) + (digits % 2)))

  printf -v line "%0${middle}d" "0"

  local left right
  left="${line:$((leftover + (digits / 2)))}"
  right="${line:$((digits / 2))}"

  echo -e "$(set_colour $1)${left//0/$lc}$2${right//0/$lc}\n"
  reset
}

show-slide() {
  local show_slide slide_count

  slide_count=1

  show_slide="$1"
  [[ -z "$show_slide" ]] && show_slide=1

  while true; do
    local chunk code bytes

    IFS="\n" read -r chunk
    code=$?
    bytes="${#chunk}"

    if ((code != 0)); then
      return 0
    fi

    if [[ "$chunk" =~ ^--- ]]; then
      ((slide_count++))
      continue
    fi

    if ((slide_count > show_slide)); then
      break
    fi

    if ((slide_count != show_slide)); then
      continue
    fi

    style_line "$chunk"
  done
}

clear

slide=$(show-slide "$1" < ./slides.md)
if [[ -z "$slide" ]]; then
  echo "Slide not found. Exiting"
  exit 1
fi

draw_line "$line_colour" "$1"
echo -e "$slide\n"
draw_line "$line_colour" "$1"
