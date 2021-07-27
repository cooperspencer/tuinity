# Docker Minecraft Tuinity
This Dockerfile builds the latest 1.17.1 version of Tuinity


## Quick Start
```sh
docker pull buddyspencer/tuinity
```

```sh
docker run \
  --rm \
  --name mc \
  -e MEMORYSIZE='1G' \
  -v /path/to/volume:/data:rw \
  -p 25565:25565 \
-i buddyspencer/tuinity:latest
```
```sh
docker attach mc
```

## Availability
This container will be available for AMD64 and ARM64
