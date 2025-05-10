FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE desktop + Firefox + required tools
RUN apt update && \
    apt install -y xfce4 xfce4-terminal firefox dbus-x11 x11-utils sudo curl wget nano net-tools \
    tigervnc-standalone-server novnc websockify x11-xserver-utils x11-apps && \
    apt clean

# Create .Xauthority to avoid display issues
RUN mkdir -p /root/.vnc && touch /root/.Xauthority

# Expose noVNC web access port
EXPOSE 6080

# Start script to launch desktop in browser
CMD bash -c "\
    vncserver -localhost no -SecurityTypes None -geometry 1280x720 :1 && \
    websockify --web=/usr/share/novnc/ --cert=/etc/ssl/certs/ssl-cert-snakeoil.pem 6080 localhost:5901"
