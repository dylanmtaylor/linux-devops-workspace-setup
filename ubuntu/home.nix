{ config, pkgs, ... }:

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
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.ansible
    pkgs.asciidoc
    pkgs.awscli2
    pkgs.aws-nuke
    pkgs.btop
    pkgs.buildah
    pkgs.cargo
    pkgs.certbot
    pkgs.chromedriver
    pkgs.cmake
    pkgs.curl
    pkgs.dig
    pkgs.docker
    pkgs.dos2unix
    pkgs.dotnet-sdk_7
    pkgs.fio
    pkgs.gawk
    pkgs.geckodriver
    pkgs.git
    pkgs.git-lfs
    pkgs.glances
    pkgs.gnomeExtensions.alphabetical-app-grid
    pkgs.gnomeExtensions.arcmenu
    pkgs.gnomeExtensions.caffeine
    pkgs.gnomeExtensions.dash-to-panel
    pkgs.go
    pkgs.google-cloud-sdk
    pkgs.graphviz
    pkgs.htop
    pkgs.iftop
    pkgs.ioping
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubetail
    pkgs.jq
    pkgs.maven
    pkgs.minikube
    pkgs.nerdfonts
    pkgs.neofetch
    pkgs.neovim
    pkgs.nmap
    pkgs.nodejs
    pkgs.p7zip
    pkgs.packer
    pkgs.podman
    pkgs.powershell
    pkgs.pngcrush
    pkgs.pv
    pkgs.python3
    pkgs.rar
    pkgs.ruby
    pkgs.shellcheck
    pkgs.skopeo
    pkgs.speedtest-cli
    pkgs.ssm-session-manager-plugin
    pkgs.starship
    pkgs.tcpdump
    pkgs.temurin-bin
    pkgs.texlive.combined.scheme-full
    pkgs.terracognita
    pkgs.terraform
    pkgs.terraform-docs
    pkgs.terraformer
    pkgs.tfsec
    pkgs.tldr
    pkgs.topgrade
    pkgs.tree
    pkgs.unar
    pkgs.vagrant
    pkgs.vault
    pkgs.vim
    pkgs.whois
    pkgs.wget
    pkgs.yarn
    pkgs.yq
    pkgs.zsh
  ];
}
