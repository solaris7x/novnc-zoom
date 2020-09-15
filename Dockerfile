FROM ubuntu:focal

#Set apt to non-interactive
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    PORT=8080 \
    PATH=/usr/local/openresty/nginx/sbin:$PATH

# Install desktop + midori + zoom + cleanup
RUN apt-get update; apt-get clean \
    && apt-get install -qqy x11vnc xvfb wget wmctrl openbox xdg-utils pulseaudio gettext-base curl \
    && apt install -qqy --no-install-recommends midori wget gnupg ca-certificates lsb-release \
    && wget -O - https://openresty.org/package/pubkey.gpg | apt-key add - \
    && echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/openresty.list \
    && apt-get update \
    && apt install -qqy --no-install-recommends openresty \
    && wget --no-check-certificate -qO '/tmp/zoom.deb' 'https://zoom.us/client/latest/zoom_amd64.deb' \
    && apt install -qqy --no-install-recommends '/tmp/zoom.deb' \
    && rm -rf '/tmp/zoom.deb' \
    && rm -rf /var/lib/apt/lists/*;

# Copy Bootstrap script 
COPY ./scripts/bootstrap.sh /bootstrap.sh
COPY ./scripts/launch_zoom.sh /resty/launch_zoom.sh

# Copy easy-novnc https://github.com/pgaskin/easy-novnc
COPY ./binary/easy-novnc_linux-64bit /easy-novnc_linux-64bit
# Copy NGINX (OpenResty) config
COPY ./nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./nginx/site.conf.template /resty/conf.d/default.conf.template

#Add user apps and set root passwd to "docker"
## add permissions for nginx user
RUN chmod 755 /bootstrap.sh; \
    chmod 755 /resty/launch_zoom.sh; \
    echo 'root:docker' | chpasswd; \
    useradd -ms /bin/bash apps; \
    chown -R apps:apps /resty/; \
    chown -R apps:apps /usr/local/openresty/nginx/logs/; 

USER apps
WORKDIR /home/apps/

CMD '/bootstrap.sh'