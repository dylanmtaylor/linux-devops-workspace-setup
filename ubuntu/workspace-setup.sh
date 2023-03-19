#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=true
export DEBIAN_PRIORITY=critical

# Do a system upgrade and install some pre-reqs
sudo -E apt update && sudo -E apt -y full-upgrade
sudo -E apt -y install unzip p7zip-full curl wget gpg flatpak gnome-software-plugin-flatpak build-essential zsh
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Run Flatpak updates if any are available
sudo -E flatpak update -y

# GNOME Packages
sudo -E apt -y install chrome-gnome-shell gnome-tweaks gnome-shell-extension-manager

# Google Chrome (and some various packages that are dependencies)
if ! command -v google-chrome &> /dev/null
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
sudo -E apt -y install meld btop htop remmina neofetch nmap ncat wireshark-gtk tcpdump filezilla ghex texlive asciidoc certbot fio glances iftop ioping iotop iptraf-ng nmon pngcrush pv setools

# Image editing and media
sudo -E apt -y install krita inkscape pinta vlc obs-studio shutter audacity

# Peek screen recorder
sudo -E add-apt-repository ppa:peek-developers/stable -y
sudo -E apt update
sudo -E apt install peek -y

# Podman
sudo -E apt -y install podman buildah skopeo crun
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $(whoami)
sudo podman system migrate
cat <<EOF | sudo tee /etc/containers/registries.conf
unqualified-search-registries = ['docker.io']

[[registry]]
# In Nov. 2020, Docker rate-limits image pulling.  To avoid hitting these
# limits, always use the google mirror for qualified and unqualified `docker.io` images.
# Ref: https://cloud.google.com/container-registry/docs/pulling-cached-images
prefix="docker.io"
location="mirror.gcr.io"
EOF

# Distrobox
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

# Development tools: OpenJDK 11, Rust and NodeJS, etc.
sudo -E apt -y install openjdk-11-jdk nodejs cargo npm yarn maven ansible golang python3-pip neovim whois ruby-dev ruby-serverspec dotnet6 cmake
sudo -E apt -y install php-cli php-common php-gd php-xml php8.1-cli php8.1-common php8.1-gd php8.1-opcache php8.1-readline php8.1-xml php-pear
sudo -E gem install webdrivers rails serverspec

# Terraformer 
curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-all-linux-amd64
chmod +x terraformer-all-linux-amd64
sudo mv terraformer-all-linux-amd64 /usr/bin/terraformer

# TerraCognita
curl -L https://github.com/cycloidio/terracognita/releases/latest/download/terracognita-linux-amd64.tar.gz -o terracognita-linux-amd64.tar.gz
tar -xf terracognita-linux-amd64.tar.gz
chmod u+x terracognita-linux-amd64
sudo mv terracognita-linux-amd64 /usr/local/bin/terracognita
rm terracognita-linux-amd64.tar.gz

# tfedit and tfmigrate
go install github.com/minamijoyo/tfedit@latest
go install github.com/minamijoyo/tfmigrate@latest

# AWS Session Manager and AWS Nuke
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo -E dpkg -i session-manager-plugin.deb
rm -f session-manager-plugin.deb
sudo -E apt -y install aws-nuke

# GitKraken
sudo -E snap install gitkraken --classic

# Postman
sudo -E snap install postman

# PowerShell
sudo -E snap install powershell --classic

# Helm
sudo -E snap install helm --classic

# Kubectl
sudo -E snap install kubectl --classic

# Starship
sudo -E snap install starship --edge

# JetBrains community IDEs
sudo -E snap install pycharm-community --classic
sudo -E snap install intellij-idea-community --classic --edge

# Eclipse
sudo -E snap install eclipse --classic

# Slack
sudo -E snap install slack

# Flatseal
sudo -E flatpak install flathub com.github.tchx84.Flatseal -y

# DBeaver
sudo -E flatpak install flathub io.dbeaver.DBeaverCommunity -y

# PeaZip
sudo -E flatpak install flathub io.github.peazip.PeaZip -y

# Bottles
sudo -E flatpak install flathub com.usebottles.bottles -y

# Zenmap
sudo -E flatpak install flathub org.nmap.Zenmap -y

# Microsoft Edge (for compatibility testing)
sudo -E flatpak install flathub com.microsoft.Edge -y

# Okteta
sudo -E flatpak install flathub org.kde.okteta -y

# Draw.io
sudo -E flatpak install flathub com.jgraph.drawio.desktop -y

# GIMP
sudo -E flatpak install flathub org.gimp.GIMP -y

# Podman Desktop
sudo -E flatpak install io.podman_desktop.PodmanDesktop -y

# Okular
sudo -E flatpak install flathub org.kde.okular -y

# This replaces the AWS client with a newer version
sudo -E apt remove -y awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
rm -rf ./aws
aws --version

# Google Cloud SDK
sudo -E snap install google-cloud-sdk --classic

# Replace LibreOffice with Flatpak version
sudo -E apt remove -y libreoffice-base-core libreoffice-calc libreoffice-common libreoffice-core libreoffice-draw libreoffice-gnome libreoffice-gtk3 libreoffice-help-common libreoffice-help-en-gb libreoffice-help-en-us libreoffice-help-fr libreoffice-help-ja libreoffice-help-ko libreoffice-help-zh-cn libreoffice-help-zh-tw libreoffice-impress libreoffice-l10n-en-gb libreoffice-l10n-en-za libreoffice-l10n-fr libreoffice-l10n-ja libreoffice-l10n-ko libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw libreoffice-math libreoffice-pdfimport libreoffice-style-breeze libreoffice-style-colibre libreoffice-style-elementary libreoffice-style-yaru libreoffice-writer
sudo -E flatpak install flathub org.libreoffice.LibreOffice -y

# Oh My ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Docker
if ! command -v docker &> /dev/null
then
    curl -fsSL https://get.docker.com | bash
    sudo -E usermod -aG docker $(whoami)
    sudo -E systemctl enable --now docker
    sudo chown $(whoami) /var/run/docker.sock # This is not very secure, but it's the only way I've found to get this working with a domain user.
    ## Make DNS work:
    sed -i '/DNSStubListenerExtra/c\DNSStubListenerExtra=172.17.0.1' /etc/systemd/resolved.conf
    sudo systemctl restart systemd-resolved
    echo '{ "dns": ["172.17.0.1"] }' | sudo tee /etc/docker/daemon.json
    sudo systemctl restart docker
fi

# Chef repository
wget -qO - https://packages.chef.io/chef.asc | sudo apt-key add -
echo "deb https://packages.chef.io/repos/apt/stable focal main" | sudo -E tee /etc/apt/sources.list.d/chef-stable.list

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

# JD GUI
wget https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.deb
sudo -E apt install ./jd-gui-1.6.6.deb -y
rm -f ./jd-gui-1.6.6.deb

# Speedtest CLI
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo -E bash
sudo -E apt-get -y install speedtest

# Topgrade for easy system upgrades
cargo install topgrade cargo-update
sed -i '/export PATH/c\export PATH=\$PATH:/home/$(whoami)/.cargo/bin/:/home/$(whoami)/go/bin/' ~/.zshrc 

# Make app grid alphabetical initially
gsettings set org.gnome.shell app-picker-layout "[]"

# GNOME Extension Installer Script
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x gnome-shell-extension-installer
sudo -E mv gnome-shell-extension-installer /usr/bin/

# GNOME Extensions I Like
gnome-shell-extension-installer 4269 # Alphabetical App Grid
gnome-shell-extension-installer 3628 # ArcMenu
gnome-shell-extension-installer 517  # Caffeine
gnome-shell-extension-installer 1160 # Dash to Panel

# Nerd Fonts
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts ~/nerd-fonts 
cd ~/nerd-fonts
./install.sh


echo "Done. A reboot is required."
