## This was originally written for my personal use, in case I recreate my workspace but others may find this valuable. Free to use or modify however you want.
## Tested on Standard Amazon Linux 2 Workspace
sudo amazon-linux-extras install epel kernel-ng ruby3.0 python3.8 java-openjdk11 mono php8.0
sudo yum -y update
sudo yum -y install nodejs npm
sudo yum -y install php-xml php-gd php-posix
sudo curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo yum -y install chromium docker neofetch htop code terraform packer vault vagrant consul nomad boundary waypoint ansible remmina wireshark-gnome go powershell python-pip nano neovim texlive asciidoc certbot fio glances iftop ioping iotop iptraf-ng lshw nmon pngcrush pv setools tcpdump telnet whois xterm
sudo rpm -vhU https://nmap.org/dist/nmap-7.92-1.x86_64.rpm
sudo rpm -vhU https://nmap.org/dist/zenmap-7.92-1.noarch.rpm
sudo rpm -vhU https://nmap.org/dist/ncat-7.92-1.x86_64.rpm
sudo rpm -vhU https://nmap.org/dist/nping-0.7.92-1.x86_64.rpm
wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm
sudo yum install ./gitkraken-amd64.rpm
sudo gpasswd -a "$USER" docker
sudo systemctl enable --now docker
curl https://intoli.com/install-google-chrome.sh | sudo bash
sudo yum -y install rubygems ruby-devel rubygem-rspec gcc gcc-c++
gem install serverspec
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
sudo yum install -y session-manager-plugin.rpm
sudo yum group install "Development Tools" -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# This replaces the AWS client with a newer version
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo rm /usr/bin/aws || true
rm awscliv2.zip
aws --version
sudo yum -y install flatpak
# Add Flathub so packages can be installed from there
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub com.microsoft.Teams -y
sudo flatpak install flathub io.dbeaver.DBeaverCommunity -y
sudo flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community -y
sudo flatpak install flathub com.jetbrains.PyCharm-Community -y
sudo flatpak install flathub io.atom.Atom -y
sudo flatpak install flathub org.gnome.GHex -y
sudo flatpak install flathub org.kde.okteta -y
sudo flatpak install flathub org.filezillaproject.Filezilla -y
sudo flatpak install flathub org.gnome.meld -y
sudo flatpak install flathub org.videolan.VLC -y
sudo flatpak install flathub com.github.PintaProject.Pinta -y
sudo flatpak install flathub org.inkscape.Inkscape -y
# Replace GIMP with Flatpak version
sudo yum -y remove gimp
sudo flatpak install flathub org.gimp.GIMP -y
# Replace bundled LibreOffice with Flatpak version
sudo yum remove libreoffice\* -y
sudo flatpak install flathub org.libreoffice.LibreOffice -y
# Replace bundled Firefox with Flatpak version
sudo yum -y remove Firefox
sudo flatpak install flathub org.mozilla.firefox -y
sudo flatpak update -y
sudo yum -y install yum-cron
sudo sed -i 's|^apply_updates = no|apply_updates = yes|' /etc/yum/yum-cron.conf
sudo sed -i 's|^random_sleep = 360|random_sleep = 0|' /etc/yum/yum-cron.conf
sudo systemctl enable --now yum-cron.service
