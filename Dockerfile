FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    xterm \
    tigervnc-standalone-server \
    novnc \
    websockify \
    supervisor \
    sudo \
    apt-utils \
    wget curl git net-tools nano \
    chromium-browser

# Set up VNC
RUN mkdir -p ~/.vnc \
 && echo '#!/bin/sh\nstartxfce4 &' > ~/.vnc/xstartup \
 && chmod +x ~/.vnc/xstartup

# Create self-signed cert for noVNC
RUN mkdir -p /etc/ssl/novnc \
 && openssl req -new -x509 -days 365 -nodes \
    -out /etc/ssl/novnc/self.pem -keyout /etc/ssl/novnc/self.pem \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost"

# Supervisor config
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord", "-n"]
