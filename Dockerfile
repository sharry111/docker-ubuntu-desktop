# Base image
FROM ubuntu:22.04

# Set environment variables to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Java for Minecraft
RUN apt update && apt install -y \
    sudo \
    wget \
    curl \
    unzip \
    gnupg \
    software-properties-common \
    net-tools \
    nano \
    supervisor \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    xfce4 \
    xrdp \
    firefox \
    openjdk-17-jre-headless && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Set up RDP
RUN adduser --disabled-password --gecos "" ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    adduser ubuntu sudo && \
    echo xfce4-session > /home/ubuntu/.xsession && \
    chown ubuntu:ubuntu /home/ubuntu/.xsession && \
    service xrdp start

# Expose RDP port
EXPOSE 3389

# Set default user to ubuntu
USER ubuntu

# Set working directory
WORKDIR /home/ubuntu

# Start XRDP on container start
CMD ["/usr/sbin/xrdp", "--nodaemon"]
