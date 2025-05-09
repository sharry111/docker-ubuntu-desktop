# Base image with Ubuntu and essential tools
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt update && apt install -y \
    sudo \
    wget \
    curl \
    unzip \
    gnupg \
    software-properties-common \
    openjdk-17-jre-headless \
    xfce4 \
    xrdp \
    firefox \
    nano \
    git \
    net-tools \
    supervisor \
    lsb-release \
    apt-transport-https \
    ca-certificates && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Create a user
RUN useradd -m -s /bin/bash minecraft && echo 'minecraft:minecraft' | chpasswd && adduser minecraft sudo

# Expose RDP port
EXPOSE 3389

# PufferPanel Web UI
EXPOSE 8080

# Install PufferPanel
RUN curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash && \
    apt install -y pufferpanel && \
    pufferpanel user add --username admin --email admin@example.com --password admin123 --name "Admin"

# Enable PufferPanel on boot
RUN systemctl enable pufferpanel || true

# Copy supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start services via supervisord
CMD ["/usr/bin/supervisord"]
