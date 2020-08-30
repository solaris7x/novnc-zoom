FROM ubuntu:focal

#Setup easy-novnc https://github.com/pgaskin/easy-novnc
ENV NOVNC_FOLDER=/home/apps/novnc \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

# Install x11vnc.
RUN apt-get update; apt-get clean; \
    apt-get install -y x11vnc xvfb wget wmctrl sudo openbox xdg-utils \
    && apt install -y --no-install-recommends midori 


# Add a user for running applications.
RUN useradd -m apps

# Give sudo access to non-root user 'apps'
RUN echo "apps  ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/apps

# Supress sudo setrlimit , find at github issue https://github.com/sudo-project/sudo/issues/42#
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

#Setup herbstluft
RUN mkdir -p ${NOVNC_FOLDER}

#Install zoom 
RUN wget --no-check-certificate -O '/home/apps/zoom.deb' 'https://zoom.us/client/latest/zoom_amd64.deb' \
    && apt install -y --no-install-recommends '/home/apps/zoom.deb' \
    && rm -rf '/home/apps/zoom.deb' \
    && rm -rf /var/lib/apt/lists/*

# Copy Bootstrap script
COPY bootstrap.sh /bootstrap.sh
COPY easy-novnc_linux-64bit ${NOVNC_FOLDER}/easy-novnc_linux-64bit
RUN chmod 755 /bootstrap.sh
USER apps

CMD '/bootstrap.sh'