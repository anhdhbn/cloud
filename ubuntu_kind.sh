# /bin/bash
sudo apt-get update
sudo apt install -y software-properties-common apt-transport-https

# swap 
SWAP_FOLDER="/swapfile"
if grep -q "$SWAP_FOLDER" /etc/fstab
then
  echo "$SWAP_FOLDER was swaped"
else
  sudo fallocate -l 8G $SWAP_FOLDER
  sudo chmod 600 $SWAP_FOLDER
  sudo mkswap $SWAP_FOLDER
  sudo swapon $SWAP_FOLDER
  echo "$SWAP_FOLDER none swap sw 0 0" | sudo tee -a /etc/fstab
fi

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
DEB_KUBECTL="deb https://apt.kubernetes.io/ kubernetes-xenial main"
DEB_KUBECTL_FOLDER="/etc/apt/sources.list.d/kubernetes.list"
if grep -q "$DEB_KUBECTL" "$DEB_KUBECTL_FOLDER"
then
  echo "Deb kubectl was added"
else
  echo "$DEB_KUBECTL" | sudo tee -a "$DEB_KUBECTL_FOLDER"
  sudo apt-get update
  sudo apt-get install -y kubectl docker.io
fi

# install kind
sudo curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-$(uname)-amd64"
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

sudo kind create cluster