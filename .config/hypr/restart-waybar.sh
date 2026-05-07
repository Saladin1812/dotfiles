#!/usr/bin/env bash

pkill -x waybar 2>/dev/null || true
waybar >/dev/null 2>&1 &
