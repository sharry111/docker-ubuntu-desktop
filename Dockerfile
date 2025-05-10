FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE desktop, VNC, noVNC, RDP basics
RUN apt update && apt install -y --no-install-recommends \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    xterm net-tools sudo curl wget git vim \
    dbus-x11 x11-utils x11-xserver-utils x11-apps \
    software-properties-common

# Clean any snap-based Firefox, install .deb Firefox from PPA
RUN if command -v snap >/dev/null 2>&1; then snap remove firefox || true; fi && \
    apt purge -y firefox snapd && \
    rm -rf /home/*/.mozilla /root/.mozilla && \
    add-apt-repository -y ppa:mozillateam/ppa && \
    echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' > /etc/apt/preferences.d/mozillateam && \
    echo 'Unattended-Upgrade::Allowed-Origins { "LP-PPA-mozillateam:jammy"; };' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox && \
    apt update && apt install -y firefox && \
    update-alternatives --set x-www-browser /usr/bin/firefox && \
    update-alternatives --set gnome-www-browser /usr/bin/firefox

# Set up noVNC and expose browser-based desktop over port 6080
RUN mkdir -p ~/.vnc && \
    echo '#!/bin/bash\nstartxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup && \
    touch /root/.Xauthority

EXPOSE 6080

CMD bash -c "\
    vncserver :1 -localhost no -SecurityTypes None -geometry 1280x800 --I-KNOW-THIS-IS-INSECURE && \
    websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/certs/ssl-cert-snakeoil.pem 6080 localhost:5901 && \
    tail -f /dev/null"
