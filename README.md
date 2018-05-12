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

### in your profile

```bash
# first argument the volume name
function toolbox-run {
    docker volume create ${1}
    docker run \
        --env TERM \
        --link docker-binder:docker  \
        --mount source=${1},target=/home/$(whoami) \
        -ti --rm toolbox-$(whoami):latest bash
}
```

```bash
docker run --privileged --name docker-binder -d docker:stable-dind
toolbox-run home
```