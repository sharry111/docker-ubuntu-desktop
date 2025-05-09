# Dockerfile: RDP + Browser + Java (PaperMC 1.21.4) + Multi-user Panel (PufferPanel)

FROM ubuntu:22.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install core utilities, desktop, RDP, and Java
RUN apt update && apt install -y \
    sudo wget curl unzip gnupg \
    software-properties-common net-tools nano supervisor lsb-release apt-transport-https ca-certificates \
    xfce4 xrdp firefox openjdk-17-jre-headless

# Clean up
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Create a user (you can create more later)
RUN useradd -m -s /bin/bash paneluser && echo 'paneluser:panelpass' | chpasswd && adduser paneluser sudo

# Install PufferPanel
RUN curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash \
 && apt install -y pufferpanel \
 && systemctl enable pufferpanel

# Configure XRDP
RUN systemctl enable xrdp

# RDP
EXPOSE 3389

# PufferPanel Web UI
EXPOSE 8080


# Start services using supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
