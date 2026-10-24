#!/bin/sh

set -eu

PACKAGES=$1

xargs tlmgr install < "$PACKAGES"
