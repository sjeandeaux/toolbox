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
docker run -v ${HOME}/.aws:/home/$(whoami)/.aws -ti --rm tools:latest bash
```