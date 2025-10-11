#!/bin/bash
if pgrep -f 'gammastep.*-O' > /dev/null; then
    ps aux | grep 'gammastep.*-O' | grep -v grep | sed -n 's/.*gammastep.*-O \([0-9]\+\).*/temp \1/p'
fi
