# WIP - ToolBox

Dockefile contains my required tools.

## Build

```bash
docker build --build-arg LOGIN=$(whoami) \
             --build-arg UID=$(id -u) \
             --build-arg GID=$(id -g) \
             --tag tools:latest --file Dockerfile .
```

## Run

```bash
docker run --privileged --name docker-binder -d docker:stable-dind

docker volume create work

docker run \
    --link docker-binder:docker  \
    --mount source=work,target=/home/$(whoami) \
    -ti --rm tools:latest bash

docker run \
 --link docker-binder:docker \
 -ti --rm tools:latest bash
```