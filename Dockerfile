
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE, noVNC, websockify, and Chromium
RUN apt update && apt install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    novnc \
    websockify \
    sudo \
    xterm \
    net-tools \
    curl \
    wget \
    git \
    vim \
    chromium-browser \
    x11-utils \
    x11-xserver-utils \
    x11-apps \
    dbus-x11 \
    tzdata

# Fix VNC insecure error and setup
RUN mkdir -p ~/.vnc && \
    echo '#!/bin/bash\nstartxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup && \
    touch /root/.Xauthority

EXPOSE 6080

CMD bash -c "vncserver :1 -localhost no -SecurityTypes None -geometry 1280x720 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
