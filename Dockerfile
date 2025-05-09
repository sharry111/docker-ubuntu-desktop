FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install essentials
RUN apt update && apt install -y sudo wget curl gnupg2 software-properties-common lsb-release \
    xfce4 xfce4-goodies xorg dbus-x11 x11-utils firefox \
    xrdp xterm net-tools locales openssl nano git unzip \
    openjdk-17-jdk

# Configure locale
RUN locale-gen en_US.UTF-8

# Add user with sudo access
RUN useradd -m -s /bin/bash user && echo "user:user" | chpasswd && adduser user sudo

# Setup RDP
RUN systemctl enable xrdp && echo "xfce4-session" > /home/user/.xsession && chown user:user /home/user/.xsession

# Install PufferPanel
RUN curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash && \
    apt install -y pufferpanel && \
    systemctl enable pufferpanel

# Expose necessary ports
# XRDP (RDP access)
EXPOSE 3389

# PufferPanel Web UI
EXPOSE 8080

# Start services
CMD service dbus start && \
    service xrdp start && \
    service pufferpanel start && \
    tail -f /dev/null
