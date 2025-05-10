FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install core utilities, XFCE desktop, and VNC/noVNC components
RUN apt update -y && apt install -y --no-install-recommends \
    xfce4 xfce4-goodies tigervnc-standalone-server \
    novnc websockify sudo xterm \
    curl wget git vim net-tools tzdata \
    dbus-x11 x11-utils x11-xserver-utils x11-apps \
    software-properties-common xubuntu-icon-theme \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Setup Firefox from latest Mozilla PPA
RUN add-apt-repository ppa:mozillateam/ppa -y && \
    echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' > /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:jammy";' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox && \
    apt update -y && apt install -y firefox && apt clean

# Setup Xauthority to avoid errors when starting XFCE
RUN touch /root/.Xauthority

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Start XFCE via VNC, then launch websockify for noVNC access
CMD bash -c "\
    vncserver :1 -localhost no -SecurityTypes None -geometry 1280x800 && \
    openssl req -new -subj '/CN=localhost' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
