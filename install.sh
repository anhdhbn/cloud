# /bin/bash
sudo apt-get update
sudo apt install -y software-properties-common

# swap 
SWAP_FOLDER="/swapfile"
if grep -q "$SWAP_FOLDER" /etc/fstab
then
  echo "$SWAP_FOLDER was swaped"
else
  sudo fallocate -l 4G $SWAP_FOLDER
  sudo chmod 600 $SWAP_FOLDER
  sudo mkswap $SWAP_FOLDER
  sudo swapon $SWAP_FOLDER
  echo "$SWAP_FOLDER none swap sw 0 0" | sudo tee -a /etc/fstab
fi

# install docker $(lsb_release -cs)
DEB_DOCKER="deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
sudo apt-get remove -y docker* containerd*
sudo apt autoremove
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
if ! grep -q "$DEB_DOCKER" /etc/apt/sources.list ; then
  sudo add-apt-repository "$DEB_DOCKER"
fi
sudo apt-get update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER

# install kubectl
# curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
# chmod +x ./kubectl
# sudo mv ./kubectl /usr/local/bin/kubectl
DEB_KUBECTL="deb https://apt.kubernetes.io/ kubernetes-xenial main"
DEB_KUBECTL_FOLDER="/etc/apt/sources.list.d/kubernetes.list"
if grep -q "$DEB_KUBECTL" "$DEB_KUBECTL_FOLDER"
then
  echo "Deb kubectl was added"
else
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "$DEB_KUBECTL" | sudo tee -a "$DEB_KUBECTL_FOLDER"
  sudo apt-get update
  sudo apt-get install -y kubeadm kubectl kubelet
fi

# install virtualbox
# DEB_VIRTUALBOX="deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
# wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
# sudo add-apt-repository $DEB_VIRTUALBOX
# if ! grep -q "$DEB_VIRTUALBOX" /etc/apt/sources.list ; then
#   sudo add-apt-repository "$DEB_VIRTUALBOX"
# fi
# sudo apt update && sudo apt install -y virtualbox-6.0

# install minikube
curl -Lo minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

# install kind
sudo curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-$(uname)-amd64"
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

newgrp docker