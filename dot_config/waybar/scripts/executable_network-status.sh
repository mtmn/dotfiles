#!/bin/bash

if ip link show wg-njalla 2>/dev/null | grep -q "UP"; then
    nmcli device show wlp3s0 | awk '/GENERAL.CONNECTION:/ {print $2 " ✔"}'
fi
