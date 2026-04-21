#!/usr/bin/env bash

# Get focused workspace from event, or query it if not available
if [ -n "$FOCUSED_WORKSPACE" ]; then
  CURRENT="$FOCUSED_WORKSPACE"
else
  CURRENT=$(aerospace list-workspaces --focused)
fi

if [ "$1" = "$CURRENT" ]; then
  sketchybar --set "$NAME" background.drawing=on
else
  sketchybar --set "$NAME" background.drawing=off
fi