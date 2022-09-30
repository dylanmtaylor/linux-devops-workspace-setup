#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=true
export DEBIAN_PRIORITY=critical

# Do a system upgrade
sudo -E apt update && sudo -E apt -y full-upgrade

# Google Chrome (and some various packages that are dependencies)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo -E apt update && sudo -E apt -y install ./google-chrome-stable_current_amd64.deb unzip p7zip-full curl wget gpg flatpak build-essential zsh
rm -f ./google-chrome-stable_current_amd64.deb

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo -E install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo -E sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo -E apt update && sudo -E apt -y install code

# Various networking and monitoring tools
sudo -E apt -y install meld btop htop remmina neofetch nmap ncat wireshark-gtk tcpdump filezilla ghex

# Image editing and media
sudo -E apt -y install krita gimp inkscape pinta vlc obs-studio shutter

# Development tools: OpenJDK 11, Rust and NodeJS, etc.
sudo -E apt -y install openjdk-11-jdk nodejs cargo yarn maven ansible golang python3-pip neovim 

# GitKraken
sudo -E snap install gitkraken --classic

# DBeaver
sudo -E snap install dbeaver-ce

# Postman
sudo -E snap install postman

# PowerShell
sudo -E snap install powershell --classic

# JetBrains community IDEs
sudo -E snap install pycharm-community --classic
sudo -E snap install intellij-idea-community --classic --edge

# Eclipse
sudo snap install eclipse --classic

# Oh My ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Docker
if ! command -v docker &> /dev/null
then
    curl -fsSL https://get.docker.com | bash
    sudo -E usermod -aG docker $USER
    sudo -E systemctl enable --now docker
fi

# Hashicorp Tools
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo -E tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DA418C88A3219F7B # workaround, but seems reliable at least.
echo "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo -E tee /etc/apt/sources.list.d/hashicorp.list
sudo -E apt update && sudo -E apt -y install boundary consul consul-esm consul-k8s consul-template consul-terraform-sync nomad nomad-autoscaler packer terraform terraform-ls vagrant vault waypoint

# Oracle Instant Client
sudo -E apt -y install alien libaio1
wget https://download.oracle.com/otn_software/linux/instantclient/217000/oracle-instantclient-basic-21.7.0.0.0-1.el8.x86_64.rpm
wget https://download.oracle.com/otn_software/linux/instantclient/217000/oracle-instantclient-sqlplus-21.7.0.0.0-1.el8.x86_64.rpm
wget https://download.oracle.com/otn_software/linux/instantclient/217000/oracle-instantclient-tools-21.7.0.0.0-1.el8.x86_64.rpm
wget https://download.oracle.com/otn_software/linux/instantclient/217000/oracle-instantclient-devel-21.7.0.0.0-1.el8.x86_64.rpm
sudo alien -i *.rpm
rm -f oracle*.rpm
sudo sh -c  'echo /usr/lib/oracle/21/client64/lib/ > /etc/ld.so.conf.d/oracle.conf'
sudo ldconfig

# Topgrade for easy system upgrades
cargo install topgrade