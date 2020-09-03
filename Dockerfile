FROM ubuntu:focal

#Set apt to non-interactive
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    PORT=8080

# Install desktop + midori + zoom + cleanup
RUN apt-get update; apt-get clean \
    && apt-get install -qqy x11vnc xvfb wget wmctrl openbox xdg-utils pulseaudio nginx gettext-base \
    && apt install -qqy --no-install-recommends midori \
    && wget --no-check-certificate -qO '/tmp/zoom.deb' 'https://zoom.us/client/latest/zoom_amd64.deb' \
    && apt install -qqy --no-install-recommends '/tmp/zoom.deb' \
    && rm -rf '/tmp/zoom.deb' \
    && rm -rf /var/lib/apt/lists/*;

# Copy Bootstrap script 
COPY bootstrap.sh /bootstrap.sh
# Copy easy-novnc https://github.com/pgaskin/easy-novnc
COPY ./binary/easy-novnc_linux-64bit /easy-novnc_linux-64bit
# Copy NGINX config
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/site.conf.template /etc/nginx/conf.d/default.conf.template

#Add user apps and set root passwd to "docker"
## add permissions for nginx user
RUN chmod 755 /bootstrap.sh; \
    echo 'root:docker' | chpasswd; \
    useradd -ms /bin/bash apps; \
    rm -f /etc/nginx/sites-enabled/default; \
    chown -R apps:apps /var/log/nginx; \
    chown -R apps:apps /etc/nginx/conf.d/;

USER apps

CMD '/bootstrap.sh'