#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

docker build --tag sjeandeaux/toolbox-onbuild:latest .
echo 'FROM sjeandeaux/toolbox-onbuild:latest' | \
    docker build --build-arg LOGIN=$(id -nu) \
        --build-arg UID=$(id -u) \
        --build-arg GID=$(id -g) \
        --build-arg GIT_NAME="$(git config --global --get user.name)" \
        --build-arg GIT_EMAIL="$(git config --global --get user.email)" \
        --tag toolbox-$(id -nu):latest \
        -
