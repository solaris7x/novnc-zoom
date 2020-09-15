# NoVNC-Zoom

**Shamelessly copied from [this medium post](https://medium.com/dot-debug/running-chrome-in-a-docker-container-a55e7f4da4a8)**

This project was created to create a virtual desktop in a docker container and hacky join zoom meetings.
Free attendence and morning sleep!!!💤

### The project uses:  
XVFB: virtual desktop  
OpenBox: window manager  
X11VNC: VNC server  
PulseAudio: Dummy micThe project uses:  
XVFB: virtual desktop  
OpenBox: window manager  
X11VNC: VNC server  
PulseAudio: Dummy mic 😎  
NoVNC: Http access to vnc 😋  
OpenResty: Automate zoom launch (zoomauth required)  
And Zoom ofc 😁

## Running the Docker container

```bash
docker run -d -p 8080:8080 -e VNC_SERVER_PASSWORD=password --user apps  iluvmonero/docker-xvfb
```

NoVNC accessed by `CONTAINER_IP`:8080/  
Launch zoom meeting by `CONTAINER_IP`:8080/zoom?meetid=`MEETINGID`  
To auto-join meeting `ZOOMAUTH_URL` need to be provided  
Check is nginx is working by `CONTAINER_IP`:8080/test

## Environmental Vars

| ENV                 | Default     | Description                                                         |   |
|---------------------|-------------|---------------------------------------------------------------------|---|
| PORT                | 8080        | Nginx port for http access                                          |   |
| VNC_SERVER_PASSWORD | BLANK       | Password for vnc access                                             |   |
| ZOOMAUTH_URL        | BLANK       | tar.gz file that contains .zoom folder contents for authentication  |   |
| LTIME               | 40          | Meeting time. Eg. 40 (seconds), 2m (minutes)                        |   |
| PUBLIC_URL          | localhost   | URL to container , might be helpful to keep container awake         |   |
| XVFB_RESOLUTION     | 1280x720x16 | Virtual screen resolution                                           |   |

## **Note**
While the _`VNC_SERVER_PASSWORD`_ argument is optional, it is not if you are using the macOS VNC viewer. If you do not set a password on macOS, you will not be able to connect to the container’s VNC server.

This container has a non-root user **_apps_** created in Dockerfile , root passwd =_docker_

Please check if your GUI app needed `--privileged` flag , as some popular apps like chrome need it
