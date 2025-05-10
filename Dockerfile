FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE, Chromium, and noVNC dependencies
RUN apt update && apt install -y \
  xfce4 xfce4-goodies x11-xserver-utils dbus-x11 xterm \
  tigervnc-standalone-server novnc websockify \
  chromium-browser sudo wget curl net-tools

# Setup VNC password and config
RUN mkdir -p /root/.vnc && \
    echo "1234" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    echo "#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    touch /root/.Xresources

# Expose noVNC port
EXPOSE 6080

# Startup command
CMD bash -c "\
vncserver :1 -localhost no -SecurityTypes None -geometry 1280x800 -xstartup /root/.vnc/xstartup --I-KNOW-THIS-IS-INSECURE && \
websockify --web=/usr/share/novnc/ --cert=/etc/ssl/certs/ssl-cert-snakeoil.pem --key=/etc/ssl/private/ssl-cert-snakeoil.key 6080 localhost:5901 & \
tail -f /dev/null"
