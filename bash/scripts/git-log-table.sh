#!/bin/sh

cols=$(tput cols)
width=$((cols - 12))

git log --format="%<($width,trunc)%s %cd" --date=short
