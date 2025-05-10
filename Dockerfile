FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    chromium-browser \
    tigervnc-standalone-server \
    supervisor \
    wget curl net-tools \
    xterm dbus-x11 \
    novnc websockify \
    && apt clean

# Create VNC password (no authentication)
RUN mkdir -p ~/.vnc && \
    echo "" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Setup supervisor config for VNC and noVNC
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the noVNC port
EXPOSE 6080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
