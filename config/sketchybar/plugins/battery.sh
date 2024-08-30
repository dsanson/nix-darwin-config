#!/bin/sh

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# no icon if charging
if [ "$CHARGING" != "" ]; then
  ICON="⚡︎"
else
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=""
    ;;
    [6-8][0-9]) ICON=""
    ;;
    [3-5][0-9]) ICON=""
    ;;
    [1-2][0-9]) ICON=""
    ;;
    *) ICON=""
  esac
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    label="$LABEL" \
    label.padding_left="-19" \
    label.font.size="22.0" \

