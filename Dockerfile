FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install essentials
RUN apt update && apt install -y \
    supervisor \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    chromium-browser \
    python3-pip \
    sudo wget curl \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Create VNC user
RUN useradd -m -s /bin/bash vncuser && echo "vncuser:vncuser" | chpasswd && adduser vncuser sudo

# Setup supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create noVNC self-signed cert
RUN mkdir -p /etc/ssl/novnc && \
    openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout /etc/ssl/novnc/self.pem \
    -out /etc/ssl/novnc/self.pem \
    -days 365 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost"

# Setup VNC password (no auth)
RUN mkdir -p /home/vncuser/.vnc && \
    echo -n > /home/vncuser/.vnc/passwd && \
    chmod 600 /home/vncuser/.vnc/passwd && \
    chown -R vncuser:vncuser /home/vncuser/.vnc

EXPOSE 6080

CMD ["/usr/bin/supervisord"]
