FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base desktop + VNC + noVNC
RUN apt update && apt install --no-install-recommends -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    sudo xterm net-tools curl wget git \
    vim dbus-x11 x11-utils x11-xserver-utils x11-apps \
    software-properties-common tzdata xubuntu-icon-theme

# Remove snap-based Firefox and install real Firefox (deb version)
RUN snap remove firefox || true && \
    apt purge -y firefox && \
    rm -rf /home/*/.mozilla /root/.mozilla && \
    add-apt-repository -y ppa:mozillateam/ppa && \
    apt update && apt install -y firefox && \
    update-alternatives --set x-www-browser /usr/bin/firefox && \
    update-alternatives --set gnome-www-browser /usr/bin/firefox

# Setup VNC and noVNC
RUN mkdir -p ~/.vnc && \
    echo "#!/bin/bash\nstartxfce4 &" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup && \
    touch /root/.Xauthority

# Expose VNC and noVNC ports
EXPOSE 5901
EXPOSE 6080

# Start VNC server + noVNC
CMD bash -c "\
    vncserver :1 -geometry 1280x720 -SecurityTypes None --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj \"/C=JP\" -x509 -days 365 -nodes -out /root/self.pem -keyout /root/self.pem && \
    websockify --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901 & \
    tail -f /dev/null"
