# Docker-xvfb

**Shamelessly copied from [this medium post](https://medium.com/dot-debug/running-chrome-in-a-docker-container-a55e7f4da4a8)**

## Running the Docker container

```bash
docker run -p 4590:5900 -e VNC_SERVER_PASSWORD=password --user apps --privileged iluvmonero/docker-xvfb:barebones-focal
```

This will launch a new Docker container and run Xvfb, Fluxbox, and a VNC server. You can access the container’s display by pointing a VNC client to docker_host_ip:4590

**Note**: While the _`VNC_SERVER_PASSWORD`_ argument is optional, it is not if you are using the macOS VNC viewer. If you do not set a password on macOS, you will not be able to connect to the container’s VNC server.

This container has a non-root user **_apps_** created in Dockerfile, thus any other `--user` argument probably won't work
