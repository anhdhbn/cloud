# /bin/bash
sudo apt-get update
sudo apt install -y software-properties-common apt-transport-https curl

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

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
DEB_DOCKER="deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
DEB_DOCKER_FOLDER="/etc/apt/sources.list.d/kubernetes.list"
if grep -q "$DEB_DOCKER" "$DEB_DOCKER_FOLDER"
then
  echo "Deb DOCKER was added"
else
  echo "$DEB_DOCKER" | sudo tee -a "$DEB_DOCKER_FOLDER"
  sudo apt-get update
  sudo apt-get install -y docker-ce
fi

# install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# install minikube
curl -Lo minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/


sudo minikube start  --v=7 --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --no-vtx-check --wait=false --driver=none