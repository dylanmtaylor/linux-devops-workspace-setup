### The following is an unsupported hack to install the GNOME desktop environment. Proceed with caution.

sudo yum -y install gnome\*

cat <<EOF | sudo tee /etc/pcoip-agent/pcoip-agent.conf
pcoip.desktop_session = gnome
EOF