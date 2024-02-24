# Update Fleek configuration then run fleek update and fleek apply
curl -L https://raw.githubusercontent.com/dylanmtaylor/amazon-linux-devops-workspace-setup/main/.fleek.yml > $HOME/.local/share/fleek/.fleek.yml
sed -i "s/dylantaylor-pc/$(hostname)/g" $HOME/.local/share/fleek/.fleek.yml
sed -i "s/username: dylan/username: $USER/g" $HOME/.local/share/fleek/.fleek.yml
rm $HOME/.fleek.yaml
ln -s $HOME/.local/share/fleek/.fleek.yml $HOME/.fleek.yaml
nix run "https://getfleek.dev/latest.tar.gz" -- update
nix run "https://getfleek.dev/latest.tar.gz" -- apply
