FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt update && apt install -y \
    sudo xfce4 xfce4-goodies xrdp dbus-x11 \
    firefox nano wget curl net-tools \
    && apt clean

# Create a user with password "user"
RUN useradd -m user && echo "user:user" | chpasswd && adduser user sudo

# Configure XRDP
RUN echo "xfce4-session" > /home/user/.xsession \
    && chown user:user /home/user/.xsession \
    && adduser xrdp ssl-cert

# Expose RDP port
EXPOSE 3389

# Start services
CMD ["/usr/sbin/xrdp", "--nodaemon"]
