# WIP - ToolBox

Dockefile contains my required tools.

## Build

```bash
echo 'FROM sjeandeaux/toolbox-onbuild:latest' | docker build --build-arg LOGIN=$(whoami) \
             --build-arg UID=$(id -u) \
             --build-arg GID=$(id -g) \
             --tag toolbox-$(whoami):latest -
```

## Run

```bash
docker run --privileged --name docker-binder -d docker:stable-dind

docker volume create work

docker run \
    --link docker-binder:docker  \
    --mount source=work,target=/home/$(whoami) \
    -ti --rm toolbox-$(whoami):latest bash

docker run \
 --link docker-binder:docker \
 -ti --rm toolbox-$(whoami):latest bash
```