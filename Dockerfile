FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt update && apt install -y \
    sudo \
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
    firefox \
    openjdk-17-jre-headless \
    xfce4 \
    xrdp && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Add default user with password
RUN useradd -m ubuntu && echo "ubuntu:ubuntu" | chpasswd && adduser ubuntu sudo

# Enable XRDP service
RUN systemctl enable xrdp

# Start supervisor to manage services
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose RDP port
EXPOSE 3389

CMD ["/usr/bin/supervisord"]
