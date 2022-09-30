#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=true
export DEBIAN_PRIORITY=critical

# Do a system upgrade and install some pre-reqs
sudo -E apt update && sudo -E apt -y full-upgrade
sudo -E apt -y install unzip p7zip-full curl wget gpg flatpak gnome-software-plugin-flatpak build-essential zsh
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Google Chrome (and some various packages that are dependencies)
if ! command -v docker &> /dev/null
then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo -E apt update && sudo -E apt -y install ./google-chrome-stable_current_amd64.deb 
    rm -f ./google-chrome-stable_current_amd64.deb
fi

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
sudo -E apt -y install openjdk-11-jdk nodejs cargo npm yarn maven ansible golang python3-pip neovim whois ruby-dev ruby-serverspec 

# AWS Session Manager and AWS Nuke
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo -E dpkg -i session-manager-plugin.deb
rm -f session-manager-plugin.deb
sudo -E apt -y install aws-nuke

# GitKraken
sudo -E snap install gitkraken --classic

# DBeaver
sudo -E snap install dbeaver-ce

# Postman
sudo -E snap install postman

# PowerShell
sudo -E snap install powershell --classic

# Helm
sudo snap install helm --classic

# Kubectl
sudo -E snap install kubectl --classic

# JetBrains community IDEs
sudo -E snap install pycharm-community --classic
sudo -E snap install intellij-idea-community --classic --edge

# Eclipse
sudo snap install eclipse --classic

# Bottles
flatpak install flathub com.usebottles.bottles -y

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
sed -i '/export PATH/c\export PATH=\$PATH:/home/$USER/.cargo/bin/' ~/.zshrc