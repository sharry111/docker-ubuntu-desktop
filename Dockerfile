FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_RESOLUTION=1280x720

# Install dependencies
RUN apt update && apt install -y \
  xfce4 xfce4-goodies \
  tigervnc-standalone-server tigervnc-common \
  novnc websockify \
  xterm wget sudo curl net-tools \
  python3-minimal \
  && apt clean

# Set up a default VNC password (blank)
RUN mkdir -p /root/.vnc && \
    echo "" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Create minimal Xresources and xstartup script
RUN touch /root/.Xresources && \
    echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Expose ports for VNC and noVNC
EXPOSE 5901 6080

# Start VNC and noVNC on container launch
CMD /bin/bash -c "\
vncserver :1 -geometry $VNC_RESOLUTION -SecurityTypes None && \
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080"
