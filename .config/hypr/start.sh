#!/usr/bin/env bash

awww-daemon &

awww img ~/Wallpapers/wallpaper.png &

nm-applet --indicator &

waybar &

dunst
