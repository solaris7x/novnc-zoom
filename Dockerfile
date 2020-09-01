FROM ubuntu:focal

#Set apt to non-interactive
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

# Install desktop + midori + zoom + cleanup
RUN apt-get update; apt-get clean; \
    apt-get install -y x11vnc xvfb wget wmctrl openbox xdg-utils \
    && apt install -y --no-install-recommends midori \
    && wget --no-check-certificate -O '/tmp/zoom.deb' 'https://zoom.us/client/latest/zoom_amd64.deb' \
    && apt install -y --no-install-recommends '/tmp/zoom.deb' \
    && rm -rf '/tmp/zoom.deb' \
    && rm -rf /var/lib/apt/lists/*;

# Copy Bootstrap script + easy-novnc https://github.com/pgaskin/easy-novnc
COPY bootstrap.sh /bootstrap.sh
COPY easy-novnc_linux-64bit /easy-novnc_linux-64bit

#Add user apps and set root passwd to "docker"
RUN chmod 755 /bootstrap.sh; \
    echo 'root:docker' | chpasswd; \
    useradd -ms /bin/bash apps;

USER apps

CMD '/bootstrap.sh'