FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE, VNC server, noVNC, and Firefox
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    firefox curl wget sudo net-tools \
    && apt clean

# Create a user
RUN useradd -m -s /bin/bash user && echo 'user:user' | chpasswd && adduser user sudo

# Setup VNC password
RUN mkdir -p /home/user/.vnc && \
    echo "password" | vncpasswd -f > /home/user/.vnc/passwd && \
    chown -R user:user /home/user/.vnc && \
    chmod 600 /home/user/.vnc/passwd

# Start VNC with XFCE on display :1 and launch websockify for noVNC access on port 6080
EXPOSE 6080
CMD bash -c "vncserver :1 -geometry 1280x800 -SecurityTypes None && \
             websockify --web=/usr/share/novnc/ 6080 localhost:5901 && \
             tail -f /dev/null"
