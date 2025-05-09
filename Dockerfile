FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary base packages, RDP, and sudo
RUN apt update && apt install -y \
    sudo \
    xrdp \
    xfce4 \
    xfce4-goodies \
    dbus-x11 \
    x11-xserver-utils \
    net-tools \
    wget \
    curl \
    nano \
    unzip \
    gnupg \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set up RDP
RUN adduser --disabled-password --gecos "" user && \
    echo "user:user" | chpasswd && \
    adduser user sudo && \
    echo xfce4-session > /home/user/.xsession && \
    chown user:user /home/user/.xsession

EXPOSE 3389

CMD ["/usr/sbin/xrdp", "--nodaemon"]
