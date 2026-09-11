#!/bin/sh

set -eu

destination=$1
mkdir -p "$destination"
wget -O "$destination/dotter" https://github.com/SuperCuber/dotter/releases/latest/download/dotter-linux-x64-musl
chmod +x "$destination/dotter"
