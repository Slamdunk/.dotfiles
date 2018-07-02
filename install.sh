#!/bin/sh

set -ex

rsync \
    --exclude ".git/" \
    --exclude "install.sh" \
    --exclude "LICENSE" \
    -avh --no-perms . ~
