# Dockerfile: Base environment for Minecraft + Pterodactyl
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt update && apt install -y \
  sudo apt-utils curl wget unzip zip gnupg2 software-properties-common \
  openjdk-21-jre-headless git lsb-release net-tools nano \
  systemd dbus iproute2 iputils-ping locales tzdata gnupg-agent \
  ca-certificates lsof supervisor screen htop openssh-server \
  && rm -rf /var/lib/apt/lists/*

# Setup locale and timezone
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# Set up Java environment
ENV JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
ENV PATH="$JAVA_HOME/bin:$PATH"

# Optional: install Docker inside Docker
RUN curl -fsSL https://get.docker.com | sh

# Optional: install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/2.24.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose

# Create user for panel/server (optional)
RUN useradd -m -s /bin/bash mcserver

# Default workdir
WORKDIR /home/mcserver

CMD [ "bash" ]
