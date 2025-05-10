FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
  xfce4 xfce4-goodies \
  x11-xserver-utils dbus-x11 xterm \
  tigervnc-standalone-server \
  novnc websockify \
  chromium-browser \
  sudo wget curl git vim net-tools apt-utils

# Create a VNC startup script
RUN mkdir -p ~/.vnc && \
    echo '#!/bin/bash\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Fix permission issues
RUN mkdir -p /root/.vnc && touch /root/.Xauthority

# Expose ports
EXPOSE 6080

# Startup command
CMD bash -c "\
vncserver :1 -localhost no -SecurityTypes None -geometry 1280x800 -xstartup /root/.vnc/xstartup --I-KNOW-THIS-IS-INSECURE && \
openssl req -new -subj '/CN=localhost' -x509 -days 365 -nodes -out /root/self.pem -keyout /root/self.pem && \
websockify --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901 & \
tail -f /dev/null"
