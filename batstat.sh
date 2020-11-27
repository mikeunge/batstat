#!/bin/bash
#
# Author:  @mikeunge
# Version: 0.1
# 
# Show the battery percentage (%) and a small dis-, charing symbol with the percent.
# This is usefull for something like tmux.
#
# CAUTION! This only works with MacOS!
#
#
# --- Get the battery information ---
battery=$(pmset -g batt)

# check if a battery exists
if ! echo "$battery" | grep -q InternalBattery; then
    printf " %s No battery " "$icon_err"
    exit 1
fi

# Get the 'status', this shows if it's charging or draining. trim the '
status=$(awk '{print $4,$5}' <<< $battery | tr -d "'")
percent=$(grep -o "[0-9]*"% <<< $battery)

# --- Define the icons to display ---
icon_0=""
icon_25=""
icon_50=""
icon_75=""
icon_100=""
icon_charging_0=""
icon_charging_25=""
icon_charging_50=""
icon_charging_75=""
icon_charging_100=""
icon_err=""


def_battery() {
    # Pass in "charging" or "not_charging" as the mode.
    local mode=$1

    if [[ $percent < 25 ]]; then
        if [[ $mode == "charging" ]]; then
            icon=$icon_charging_0
        else
            icon=$icon_0
        fi
    elif [[ $percent > 25 ]] && [[ $percent < 50 ]]; then
        if [[ $mode == "charging" ]]; then
            icon=$icon_charging_25
        else
            icon=$icon_25
        fi
    elif [[ $percent > 50 ]] && [[ $percent < 75 ]]; then
        if [[ $mode == "charging" ]]; then
            icon=$icon_charging_50
        else
            icon=$icon_50
        fi
    elif [[ $percent > 75 ]] && [[ $percent < 90 ]]; then
        if [[ $mode == "charging" ]]; then
            icon=$icon_charging_75
        else
            icon=$icon_75
        fi
    else
        if [[ $mode == "charging" ]]; then
            icon=$icon_charging_100
        else
            icon=$icon_100
        fi
    fi
}

# display the battery
case $status in
    "AC Power")
        def_battery "charging"
        printf "%s %s \n" "$icon" "$percent" ;;
    "Battery Power")
        def_battery "not_charging"
        printf "%s %s \n" "$icon" "$percent" ;;
    *)
        printf "N/A %s %s \n" "$icon_err" "$percent" ;;
esac

