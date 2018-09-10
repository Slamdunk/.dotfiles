#!/bin/sh

set -ex

thisDir=$(readlink --canonicalize $(dirname "$0"))

rsync \
    --exclude ".git/" \
    --exclude "install.sh" \
    --exclude "LICENSE" \
    -avh --no-perms "${thisDir:?}"/. ~
