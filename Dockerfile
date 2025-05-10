FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE, RDP, Chromium, and some utilities
RUN apt update && apt install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    chromium-browser \
    dbus-x11 \
    sudo \
    wget \
    curl \
    net-tools \
    && apt clean

# Set up xrdp to use XFCE
RUN echo "xfce4-session" > /etc/skel/.xsession && \
    mkdir -p /root/.config && \
    echo "exec startxfce4" > /root/.xsession && \
    echo "startxfce4" > /root/.xinitrc && \
    adduser xrdp ssl-cert

# Fix color depth issue
RUN sed -i 's/3389/3389/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/^new_cursors=true/new_cursors=false/' /etc/xrdp/xrdp.ini

# Enable xrdp service
EXPOSE 3389
CMD ["/usr/sbin/xrdp", "--nodaemon"]
