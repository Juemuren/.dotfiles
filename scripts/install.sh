#!/bin/sh

wget https://github.com/SuperCuber/dotter/releases/latest/download/dotter-linux-x64-musl
chmod +x dotter-linux-x64-musl
mkdir -p bin
mv dotter-linux-x64-musl ./bin/dotter
