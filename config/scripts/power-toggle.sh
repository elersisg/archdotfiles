#!/bin/bash

CURRENT=$(powerprofilesctl get)

if [[ "$CURRENT" == "performance" ]]; then
    powerprofilesctl set balanced
    notify-send "Power Profile" "Balanced mode activated ⚖️"
elif [[ "$CURRENT" == "balanced" ]]; then
    powerprofilesctl set power-saver
    notify-send "Power Profile" "Power Saving mode activated 🔋"
else
    powerprofilesctl set performance
    notify-send "Power Profile" "Performance mode activated 🚀"
fi
