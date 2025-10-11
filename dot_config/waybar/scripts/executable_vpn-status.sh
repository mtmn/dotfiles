#!/bin/bash
if ! ip link show wg-njalla 2>/dev/null | grep -q "UP"; then
    echo "off"
fi
