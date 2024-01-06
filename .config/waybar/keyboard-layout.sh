#!/usr/bin/env bash

setxkbmap -query 2>/dev/null | awk '/layout/{print $2}'
