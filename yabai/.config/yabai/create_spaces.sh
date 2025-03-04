#!/bin/sh

DESIRED_SPACES_PER_DISPLAY=8
CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"
NUMBER_OF_DISPLAYS="$(yabai -m query --displays | jq -r '.[].index' | wc -l)"

if [ "$NUMBER_OF_DISPLAYS" -gt 1 ]; then
    DESIRED_SPACES_PER_DISPLAY=4
fi  

# Destroy extra spaces
for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 6)'); do
  yabai -m space --destroy 7
done

function setup_space {
  local idx="$1"
  local name="$2"
  local space=
  echo "setup space $idx : $name"

  space=$(yabai -m query --spaces --space "$idx")
  if [ -z "$space" ]; then
    yabai -m space --create
  fi

  yabai -m space "$idx" --label "$name"
}

# case $num_displays in
#   1)
#     # All spaces go to the first (and only) display
#     for i in {1..6}; do
#       yabai -m space $i --display 1
#     done
#     ;;
#   2)
#     # Spaces 1, 2, and 5 go to display 2, others to display 1
#     yabai -m space 1 --display 2
#     yabai -m space 2 --display 2
#     yabai -m space 5 --display 2
#
#     yabai -m space 3 --display 1
#     yabai -m space 4 --display 1
#     yabai -m space 6 --display 1
#     ;;
#   3)
#     # Spaces 1 and 5 go to display 1, space 2 to display 2, others to display 3
#     yabai -m space 1 --display 1
#     yabai -m space 5 --display 1
#
#     yabai -m space 2 --display 2
#
#     yabai -m space 3 --display 3
#     yabai -m space 4 --display 3
#     yabai -m space 6 --display 3
#     ;;
#   *)
#     echo "Unsupported number of displays: $num_displays"
#     ;;
# esac
#
# # Define rules for application space assignment
# yabai -m rule --add app="^Safari$" space=^3
# yabai -m rule --add app="^Firefox$" space=^3
# yabai -m rule --add app="^Telegram$" space=4
# yabai -m rule --add app="^Music$" space=5
# yabai -m rule --add app="^Spotify$" space=5


# Destroy extra spaces

DELTA=0
while read -r line
do
  LAST_SPACE="$(echo "${line##* }")"
  LAST_SPACE=$(($LAST_SPACE+$DELTA))
  EXISTING_SPACE_COUNT="$(echo "$line" | wc -w)"
  MISSING_SPACES=$(($DESIRED_SPACES_PER_DISPLAY - $EXISTING_SPACE_COUNT))
  if [ "$MISSING_SPACES" -gt 0 ]; then
    for i in $(seq 1 $MISSING_SPACES)
    do
      echo "Create Last Space: $LAST_SPACE"
      yabai -m space --create
      LAST_SPACE=$(($LAST_SPACE+1))
    done
  elif [ "$MISSING_SPACES" -lt 0 ]; then
    for i in $(seq 1 $((-$MISSING_SPACES)))
    do
      echo "Delete Last Space: $LAST_SPACE"
      yabai -m space --destroy "$LAST_SPACE"
      LAST_SPACE=$(($LAST_SPACE-1))
    done
  fi
  DELTA=$(($DELTA+$MISSING_SPACES))
done <<< "$CURRENT_SPACES"

sketchybar --trigger space_change




