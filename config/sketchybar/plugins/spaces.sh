#!/usr/bin/env bash
#PATH="/Users/desanso/.nix-profile/bin/:$PATH"

#source ../colors.sh

if [ "$SELECTED" = "true" ] || [ "$SENDER" = "mouse.entered" ]; then
  HIGHLIGHT="on"
  BG_COLOR=$SELECTED_COLOR
else 
  HIGHLIGHT="off"
  BG_COLOR=$UNSELECTED_COLOR
fi

OPTIONS=(
  label.highlight=$HIGHLIGHT
  icon.background.color=$BG_COLOR
  popup.align=left
)

if [ "$SENDER" = "mouse.exited.global" ]; then
    OPTIONS+=( popup.drawing=off )
fi


STATUS=$(sketchybar --query "${NAME}" | jq -r '.popup.drawing')
if [ "$SENDER" = "mouse.entered" ] && [[ "$STATUS" = "null" || "$STATUS" = "off" ]] ; then
  DIR=$(dirname "$0")
  OPTIONS+=( popup.drawing=on )
  SPACE=${NAME:1}

  # turn off popups for adjacent spaces
  PREV=$((SPACE - 1))
  NEXT=$((SPACE + 1))
  sketchybar \
    --remove "/${NAME}-.*/" \
    --set s$PREV \
      popup.drawing=off \
    --set s$NEXT \
      popup.drawing=off \

  n=0
  yabai -m query --windows --space $SPACE | \
    jq -r '.[] | (.id|tostring) + " : " + .app + " : " + .title' | \
    while read -r WIN; do
      ID="${WIN%% : *}"
      TITLE="${WIN##* : }"
      APP="${WIN#* : }"
      APP="${APP% : *}"
      sketchybar \
        --add item ${NAME}-${n} popup.$NAME \
        --set $NAME-${n} \
          label="${APP}: ${TITLE}" \
          click_script="yabai -m window --focus $ID; sketchybar --set $NAME popup.drawing=off" \
          script="$DIR/mouse_over.sh" \
        --subscribe $NAME-${n} mouse.entered mouse.exited

     ((n+=1))
    done
fi

sketchybar --set $NAME "${OPTIONS[@]}"

