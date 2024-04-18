#!/bin/bash

function init_widget() {

  CLICK="$HOME/bin/nowplaying-cli togglePlayPause"
  
  if [[ "$INFO" == "" ]]; then
    rate="$(nowplaying-cli get playbackRate)"
    if [[ "$rate" == "0" ]]; then
      STATE="paused"
    else
      STATE="playing"
    fi
  else
    STATE="$(jq -r '.state' <<< "$INFO")"
  fi

  case "$STATE" in
    playing)
      ICON="􀊘"
      ;;
    paused)
      ICON=""
      ;;
    *)
      exit 0
      ;;
  esac
  if [[ "$INFO" == "" ]]; then
    TITLE="$(nowplaying-cli get title)"
    ALBUM="$(nowplaying-cli get album)"
    ARTIST="$(nowplaying-cli get artist)"
  else 
    TITLE="$(jq -r '.title' <<< "$INFO")"
    ALBUM="$(jq -r '.album' <<< "$INFO")"
    ARTIST="$(jq -r '.artist' <<< "$INFO")"
    APP="$(jq -r '.app' <<< "$INFO")"
  fi

  sketchybar --set "$NAME" \
    icon="$ICON" \
    drawing=on \
    click_script="$CLICK" \
    --remove "/${NAME}-info-*/" \
    --add item "${NAME}-info-app" popup.${NAME} \
    --set "${NAME}-info-app" label="app: $APP" \
      click_script="open -a \"$APP\"" \
      align=center \
    --add item "${NAME}-info-title" popup.${NAME} \
    --set "${NAME}-info-title" label="track: $TITLE" \
      click_script="open -a \"$APP\"" \
      align=center \
    --add item "${NAME}-info-artist" popup.${NAME} \
    --set "${NAME}-info-artist" label="artist: $ARTIST" \
      click_script="open -a \"$APP\"" \
      align=center \
    --add item "${NAME}-info-album" popup.${NAME} \
    --set "${NAME}-info-album" label="album: $ALBUM" \
      click_script="open -a \"$APP\"" \
      align=center \
    
  if [[ "$APP" == "Music" ]]; then

    LOVED=$(osascript -l JavaScript -e "Application('Music').currentTrack().loved()")
    if [[ "$LOVED" == "true" ]]; then
      STATUS="󰥱"
      LABEL="click to unlove"
    else
      STATUS=""
      LABEL="click to love"
    fi

    sketchybar \
      --add item "$NAME-info-love" popup.${NAME} \
      --set "${NAME}-info-love" \
        icon="$STATUS" \
        label="$LABEL" \
        click_script="$DIR/music_click $LOVED"
  fi
}

DIR=$(dirname "$0")

case "$SENDER" in
  forced|media_change)
    init_widget
    ;;
esac


