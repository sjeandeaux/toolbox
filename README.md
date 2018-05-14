# WIP - ToolBox

Dockefile contains my required tools.

## Build

```bash
docker build --tag sjeandeaux/toolbox-onbuild:latest .

echo 'FROM sjeandeaux/toolbox-onbuild:latest' | \
    docker build --build-arg LOGIN=$(id -nu) \
        --build-arg UID=$(id -u) \
        --build-arg GID=$(id -g) \
        --build-arg GIT_NAME="$(git config --global --get user.name)" \
        --build-arg GIT_EMAIL="$(git config --global --get user.email)" \
        --tag toolbox-$(id -nu):latest \
        -
```

## Run

### in your profile

```bash
# first argument the volume name
function toolbox-run {
    nameVolume=${1:-home}
    docker volume create ${nameVolume}
    docker run \
        --env TERM \
        --env DISPLAY=${IP}:0 \
        --link docker-binder:docker  \
        --mount source=${nameVolume},target=/home/$(id -nu) \
        -ti --rm toolbox-$(id -nu):latest bash
}
```

```bash
docker run --privileged --name docker-binder -d docker:stable-dind
toolbox-run home
```