#!/bin/bash
#
source "$HOME"/.config/shell/rc/fantomas

if ! ip link show wg-njalla 2>/dev/null | grep -q "UP"; then
    njalla up
else
    njalla down
fi
