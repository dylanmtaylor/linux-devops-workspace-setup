#!/bin/bash

# Google Chrome (and some various packages that are dependencies)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt -y install ./google-chrome-stable_current_amd64.deb unzip p7zip-full curl wget gpg flatpak build-essential zsh
rm -f ./google-chrome-stable_current_amd64.deb

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update && sudo apt -y install code

# Hashicorp Tools
wget --quiet --output-document - https://apt.releases.hashicorp.com/gpg | \ sudo gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/hashicorp-archive-keyring.gpg --import
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt -y install terraform packer vault vagrant consul nomad boundary waypoint

# Oh My ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Docker
curl -fsSL https://get.docker.com | bash
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

# GitKraken
sudo snap install gitkraken --classic

# DBeaver
sudo snap install dbeaver-ce

# Postman
sudo snap install postman

# PowerShell
sudo snap install powershell --classic

# Various networking and monitoring tools
sudo apt -y install meld btop htop remmina neofetch nmap ncat wireshark-gtk tcpdump filezilla ghex

# Image editing and media
sudo apt -y install krita gimp inkscape pinta vlc obs-studio shutter

# Development tools: OpenJDK 11, Rust and NodeJS, etc.
sudo apt -y install openjdk-11-jdk nodejs cargo yarn maven ansible golang python3-pip neovim 

# Topgrade for easy system upgrades
cargo install topgrade

# Do a full upgrade
sudo apt update && sudo apt -y full-upgrade