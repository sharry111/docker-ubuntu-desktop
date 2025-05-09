# Start from an Ubuntu base
FROM ubuntu:22.04

# Disable interaction during install
ENV DEBIAN_FRONTEND=noninteractive

# Install all required packages
RUN apt-get update && apt-get install -y \
    sudo curl wget gnupg2 unzip nano software-properties-common \
    openjdk-17-jdk \
    xfce4 xfce4-goodies tightvncserver \
    xrdp firefox \
    git net-tools

# Set up a user
RUN useradd -m -s /bin/bash minecraft && \
    echo 'minecraft ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER minecraft
WORKDIR /home/minecraft

# Set up VNC password
RUN mkdir -p ~/.vnc && \
    echo "minecraft" | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd

# Create VNC startup script
RUN echo "#!/bin/bash\nstartxfce4 &" > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup

# Set up xRDP
USER root
RUN echo xfce4-session > /etc/skel/.Xsession && \
    service xrdp start

# Set custom RDP port (default is 3389)
EXPOSE 3390
RUN sed -i 's/3389/3390/' /etc/xrdp/xrdp.ini

# Download and install PufferPanel (a lightweight, multi-user game panel)
RUN curl -sSL https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash && \
    apt-get install -y pufferpanel && \
    pufferpanel user add --username admin --email admin@example.com --password admin123 --name "Admin"

# Enable and start services
RUN systemctl enable xrdp && systemctl enable pufferpanel

EXPOSE 8080 25565

# Start all services
CMD service xrdp start && \
    service pufferpanel start && \
    tail -f /dev/null
