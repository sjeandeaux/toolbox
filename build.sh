#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

docker build --tag sjeandeaux/toolbox-onbuild:latest .
echo 'FROM sjeandeaux/toolbox-onbuild:latest' | \
    docker build --build-arg LOGIN=$(whoami) \
        --build-arg UID=$(id -u) \
        --build-arg GID=$(id -g) \
        --tag toolbox-$(whoami):latest \
        -
