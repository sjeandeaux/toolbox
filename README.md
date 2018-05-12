# WIP - ToolBox

Dockefile contains my required tools.

```bash
docker build --build-arg LOGIN=$(whoami) \
             --build-arg UID=$(id -u) \
             --build-arg GID=$(id -g) \
             --tag tools:latest --file Dockerfile
```