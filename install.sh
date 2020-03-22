# /bin/bash
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

# install docker
sudo apt-get update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER

# install kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# install virtualbox
sudo add-apt-repository multiverse && sudo apt-get update
sudo apt install virtualbox -y

# install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

# install kind
sudo curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-$(uname)-amd64"
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

newgrp docker