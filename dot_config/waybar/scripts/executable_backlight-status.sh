#!/bin/bash
if ! wlr-randr | grep -qE '^DP-1|^DP-2'; then
    brightnessctl | grep -o '[0-9]\+%' | sed 's/.*/bri &/'
fi
