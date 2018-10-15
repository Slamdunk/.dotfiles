#!/bin/sh

set -ex

thisDir=$(readlink --canonicalize $(dirname "$0"))

rsync \
    --exclude ".git/" \
    --exclude "install.sh" \
    --exclude "LICENSE" \
    --exclude "README.md" \
    -avh --no-perms "${thisDir:?}"/. ~
