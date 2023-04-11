#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=true
export DEBIAN_PRIORITY=critical

# Do a system upgrade and install some pre-reqs plus GNOME packages for further system customization
sudo -E apt update && sudo -E apt -y full-upgrade
sudo -E apt -y install unzip p7zip-full curl wget gpg flatpak gnome-software-plugin-flatpak chrome-gnome-shell gnome-tweaks gnome-shell-extension-manager build-essential zsh
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Flatpak updates if any are available
sudo -E flatpak update -y

# Install Docker and configure it in a way that works with domain users and AWS workspaces networking
if ! command -v docker &> /dev/null
then
    curl -fsSL https://get.docker.com | bash
    sudo -E usermod -aG docker $(whoami)
    sudo -E systemctl enable --now docker
    sudo chown $(whoami) /var/run/docker.sock # This is not very secure, but it's the only way I've found to get this working with a domain user.
    ## Make DNS work:
    sudo sed -i '/DNSStubListenerExtra/c\DNSStubListenerExtra=172.17.0.1' /etc/systemd/resolved.conf
    sudo systemctl restart systemd-resolved
    echo '{ "dns": ["172.17.0.1"] }' | sudo tee /etc/docker/daemon.json
    sudo systemctl restart docker
fi

# Install and configure Nix. This incorporates some workarounds because of being a domain user.
if ! command -v nix-shell &> /dev/null
then
sh <(curl -L https://nixos.org/nix/install) --daemon
fi

# Try to source the nix profile
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
source /nix/var/nix/profiles/default/etc/profile.d/nix.sh

# These may need to run in a new shell
nix-shell -p nix-info --run "nix-info -m"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo mkdir -p /nix/var/nix/profiles/per-user/$USERNAME/
sudo chown "$(id -un)":"$(id -gn)" /nix/var/nix/profiles/per-user/$USERNAME/
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager init

# Write config to ~/.config/home-manager/home.nix and build and switch.
cat <<EOF > $HOME/.config/home-manager/home.nix
{ config, pkgs, ... }:
let
  master = import (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
  { config = config.nixpkgs.config; };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "taylord";
  home.homeDirectory = "/home/taylord";
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  home.packages = [
    pkgs.ansible
    pkgs.asciidoc
    pkgs.awscli2
    pkgs.aws-vault
    pkgs.aws-nuke
    pkgs.azure-cli
    pkgs.bfg-repo-cleaner
    pkgs.boundary
    pkgs.btop
    pkgs.buildah
    pkgs.cargo
    pkgs.certbot
    pkgs.chromedriver
    pkgs.cmake
    pkgs.consul
    pkgs.consul-template
    pkgs.curl
    pkgs.cyberchef
    pkgs.dconf2nix
    pkgs.dig
    pkgs.distrobox
    pkgs.dos2unix
    pkgs.dotnet-sdk_7
    pkgs.ffmpeg
    pkgs.fio
    pkgs.gawk
    pkgs.gcc
    pkgs.geckodriver
    pkgs.git
    pkgs.git-lfs
    pkgs.github-cli
    pkgs.glances
    master.gnome-extensions-cli
    pkgs.gnum4
    pkgs.gnumake
    pkgs.go
    pkgs.google-cloud-sdk
    pkgs.graphviz
    pkgs.harfbuzz
    pkgs.htop
    pkgs.iftop
    pkgs.ioping
    pkgs.jd-gui
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubetail
    pkgs.jq
    pkgs.libtool
    pkgs.maven
    master.meraki-cli
    pkgs.minikube
    pkgs.nerdfonts
    pkgs.neofetch
    pkgs.neovim
    pkgs.nmap
    pkgs.nodejs
    pkgs.nomad
    pkgs.nomad-autoscaler
    master.oracle-instantclient
    pkgs.p7zip
    pkgs.packer
    pkgs.pcre2
    pkgs.powershell
    pkgs.pngcrush
    pkgs.progress
    pkgs.pv
    pkgs.python310Full
    pkgs.python310Packages.pip
    pkgs.python310Packages.pipx
    pkgs.rar
    pkgs.ruby
    master.scalr-cli
    pkgs.shellcheck
    pkgs.skopeo
    pkgs.speedtest-cli
    pkgs.ssm-session-manager-plugin
    pkgs.starship
    pkgs.tcpdump
    pkgs.temurin-bin
    pkgs.texlive.combined.scheme-tetex
    pkgs.terracognita
    pkgs.terraform
    pkgs.terraform-docs
    pkgs.terraform-ls
    pkgs.terraformer
    pkgs.tfsec
    pkgs.tldr
    pkgs.topgrade
    pkgs.tree
    pkgs.unar
    pkgs.unzip
    pkgs.vagrant
    pkgs.vault
    pkgs.vim
    pkgs.waypoint
    pkgs.whois
    pkgs.wget
    pkgs.yarn
    pkgs.yq
    pkgs.zsh
  ];
}
EOF
home-manager switch

# Make the 'nerdfonts' available.
mkdir -p $HOME/.local/share/fonts/ # Just in case
ln -s $HOME/.nix-profile/share/fonts/* $HOME/.local/share/fonts/

# Install and enable my desired GNOME shell extensions 
gext install dash-to-panel@jderose9.github.com
gext install arcmenu@arcmenu.com
gext install AlphabeticalAppGrid@stuarthayhurst
gext install caffeine@patapon.info

# Google Chrome
if ! command -v google-chrome &> /dev/null
then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo -E apt update && sudo -E apt -y install ./google-chrome-stable_current_amd64.deb 
    rm -f ./google-chrome-stable_current_amd64.deb
fi

# Microsoft Edge
if ! command -v microsoft-edge &> /dev/null
then
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo -E install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo -E sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
    sudo -E rm microsoft.gpg
    sudo -E apt update && sudo -E apt install microsoft-edge-stable
fi

# VS Code
sudo -E sh -c 'echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo -E apt update && sudo -E apt -y install code

# Replace Firefox with Flatpak version
sudo -E apt remove -y firefox thunderbird
sudo -E snap remove firefox
sudo -E flatpak install flathub org.mozilla.firefox -y

# Replace LibreOffice with Flatpak version
sudo -E apt remove -y libreoffice-base-core libreoffice-calc libreoffice-common libreoffice-core libreoffice-draw libreoffice-gnome libreoffice-gtk3 libreoffice-help-common libreoffice-help-en-gb libreoffice-help-en-us libreoffice-help-fr libreoffice-help-ja libreoffice-help-ko libreoffice-help-zh-cn libreoffice-help-zh-tw libreoffice-impress libreoffice-l10n-en-gb libreoffice-l10n-en-za libreoffice-l10n-fr libreoffice-l10n-ja libreoffice-l10n-ko libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw libreoffice-math libreoffice-pdfimport libreoffice-style-breeze libreoffice-style-colibre libreoffice-style-elementary libreoffice-style-yaru libreoffice-writer
sudo -E flatpak install flathub org.libreoffice.LibreOffice -y

# Podman and registry configuration
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

# Chef repository
wget -qO - https://packages.chef.io/chef.asc | sudo apt-key add -
echo "deb https://packages.chef.io/repos/apt/stable focal main" | sudo -E tee /etc/apt/sources.list.d/chef-stable.list

# RDP/VNC connectivity and packet monitoring
sudo -E apt -y install remmina wireshark-gtk

# Screen capture and media playback
sudo -E apt -y install vlc mpv obs-studio shutter

# GitKraken
sudo -E snap install gitkraken --classic

# Postman
sudo -E snap install postman

# JetBrains community IDEs
sudo -E snap install pycharm-community --classic
sudo -E snap install intellij-idea-community --classic --edge

# Eclipse
sudo -E snap install eclipse --classic

# Slack
# sudo -E snap install slack

# Flatseal
sudo -E flatpak install flathub com.github.tchx84.Flatseal -y

# FileZilla
sudo -E flatpak install flathub org.filezillaproject.Filezilla -y

# Audacity
sudo -E flatpak install flathub org.audacityteam.Audacity -y

# DBeaver
sudo -E flatpak install flathub io.dbeaver.DBeaverCommunity -y

# PeaZip
sudo -E flatpak install flathub io.github.peazip.PeaZip -y

# Bottles
sudo -E flatpak install flathub com.usebottles.bottles -y

# Zenmap
sudo -E flatpak install flathub org.nmap.Zenmap -y

# Okteta
sudo -E flatpak install flathub org.kde.okteta -y

# Draw.io
sudo -E flatpak install flathub com.jgraph.drawio.desktop -y

# GIMP
sudo -E flatpak install flathub org.gimp.GIMP -y

# Inkscape
sudo -E flatpak install flathub org.inkscape.Inkscape -y

# Krita
sudo -E flatpak install flathub org.kde.krita -y

# Meld
sudo -E flatpak install flathub org.gnome.meld -y

# Pinta
sudo -E flatpak install flathub com.github.PintaProject.Pinta -y

# Podman Desktop
sudo -E flatpak install flathub io.podman_desktop.PodmanDesktop -y

# Okular
sudo -E flatpak install flathub org.kde.okular -y

# Make app grid alphabetical initially
gsettings set org.gnome.shell app-picker-layout "[]"

echo "Done. A reboot is required."
