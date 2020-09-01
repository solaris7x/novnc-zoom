# Docker-xvfb

**Shamelessly copied from [this medium post](https://medium.com/dot-debug/running-chrome-in-a-docker-container-a55e7f4da4a8)**

This will launch a new Docker container and run Xvfb, Fluxbox, and a VNC server. You can access the container’s display by pointing a VNC client to `docker_host_ip:4590`

## Running the Docker container

```bash
docker run -d -p 5900:5900 -p 8080:8080 -e VNC_SERVER_PASSWORD=password --user apps  iluvmonero/docker-xvfb
```

##Environmental Vars
PORT : NoVNC port , default 8080
VNC_SERVER_PASSWORD : password , can be left blank 

**Note**: While the _`VNC_SERVER_PASSWORD`_ argument is optional, it is not if you are using the macOS VNC viewer. If you do not set a password on macOS, you will not be able to connect to the container’s VNC server.

This container has a non-root user **_apps_** created in Dockerfile , root passwd =_docker_

Please check if your GUI app needed `--privileged` flag , as some popular apps like chrome need it
