## This was originally written for my personal use, in case I recreate my workspace but others may find this valuable. Free to use or modify however you want.
## Tested on Standard Amazon Linux 2 Workspace
sudo amazon-linux-extras install epel kernel-ng ruby3.0 python3.8 java-openjdk11 mono
sudo yum -y update
sudo curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo yum -y install chromium gimp filezilla docker meld neofetch htop code terraform packer vault vagrant consul nomad boundary waypoint ansible remmina wireshark-gnome go powershell python-pip nano neovim
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
sudo yum install https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
