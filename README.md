# WIP - ToolBox

Dockefile contains my required tools.

## Build

```bash
docker build --tag sjeandeaux/toolbox-onbuild:latest .

echo 'FROM sjeandeaux/toolbox-onbuild:latest' | \
             docker build --build-arg LOGIN=$(whoami) \
             --build-arg UID=$(id -u) \
             --build-arg GID=$(id -g) \
             --tag toolbox-$(whoami):latest -
```

## Run

```bash
docker run --privileged --name docker-binder -d docker:stable-dind

docker volume create home

docker run \
    --env TERM \
    --link docker-binder:docker  \
    --mount source=home,target=/home/$(whoami) \
    -ti --rm toolbox-$(whoami):latest bash

docker run \
 --env TERM \
 --link docker-binder:docker \
 -ti --rm toolbox-$(whoami):latest bash
```