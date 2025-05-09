# Base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install essentials
RUN apt update && apt install -y \
    sudo curl wget gnupg2 ca-certificates apt-transport-https software-properties-common \
    xfce4 xfce4-goodies xrdp firefox \
    dbus-x11 x11-utils x11-xserver-utils \
    openjdk-17-jre-headless \
    supervisor \
    unzip git

# Add user and set password
RUN useradd -m -s /bin/bash paneluser && echo 'paneluser:panelpass' | chpasswd && adduser paneluser sudo

# Install PufferPanel (multi-user server panel)
RUN curl https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash \
    && apt install -y pufferpanel \
    && pufferpanel user add --username sharrysidhu --email sharrysidhu@gmail.com --password 7789977899 --admin

# Configure XRDP
RUN echo xfce4-session > /home/paneluser/.xsession && \
    chown paneluser:paneluser /home/paneluser/.xsession

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 3389   # XRDP (RDP access)
EXPOSE 8080   # PufferPanel Web UI

# Startup
CMD ["/usr/bin/supervisord"]
