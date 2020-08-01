FROM ubuntu:focal

RUN apt-get update; apt-get clean

# Install x11vnc.
RUN apt-get install -y x11vnc xvfb fluxbox wget wmctrl sudo

# Add a user for running applications.
RUN useradd -m apps

# Give sudo access to non-root user 'apps'
RUN echo "apps  ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/apps

# Supress sudo setrlimit , find at github issue https://github.com/sudo-project/sudo/issues/42#
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# Copy Bootstrap script
COPY bootstrap.sh /bootstrap.sh
RUN chmod 755 /bootstrap.sh
USER apps

CMD '/bootstrap.sh'