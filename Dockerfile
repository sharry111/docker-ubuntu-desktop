FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Basic setup
RUN apt-get update && apt-get install -y \
    sudo apt-utils software-properties-common \
    xrdp xfce4 xfce4-goodies \
    chromium-browser \
    dbus-x11 x11-xserver-utils x11-utils x11-apps \
    net-tools curl wget git nano unzip gnupg \
    && apt-get clean

# Create default user
RUN useradd -m -s /bin/bash user && echo "user:user" | chpasswd && adduser user sudo

# Configure xrdp
RUN echo "xfce4-session" > /home/user/.xsession && \
    chown user:user /home/user/.xsession && \
    sed -i 's/console/anybody/' /etc/X11/Xwrapper.config && \
    systemctl enable xrdp

# Set custom RDP port (6080)
RUN sed -i 's/3389/6080/g' /etc/xrdp/xrdp.ini

EXPOSE 6080

CMD ["/usr/sbin/xrdp", "--nodaemon"]
