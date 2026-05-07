#!/usr/bin/env bash

awww-daemon &

awww img ~/Wallpapers/wallpaper.png &

nm-applet --indicator &

~/.config/hypr/restart-waybar.sh &

dunst
