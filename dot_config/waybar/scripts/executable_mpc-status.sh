#!/bin/bash
eval "$("$HOME/bin/amen-or-straw")"


if mpc status | grep -q '\[playing\]'; then
    mpc current -f '%artist% - %title%' 2>/dev/null | sed 's/&//g' | sed "s|$| [$(mpc | grep -oE '[0-9]+:[0-9]+/[0-9]+:[0-9]+' | head -1)]|"
fi
