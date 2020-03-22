# /bin/bash
sudo apt-get update
sudo apt install -y software-properties-common apt-transport-https

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

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
DEB_KUBECTL="deb https://apt.kubernetes.io/ kubernetes-xenial main"
DEB_KUBECTL_FOLDER="/etc/apt/sources.list.d/kubernetes.list"
if grep -q "$DEB_KUBECTL" "$DEB_KUBECTL_FOLDER"
then
  echo "Deb kubectl was added"
else
  echo "$DEB_KUBECTL" | sudo tee -a "$DEB_KUBECTL_FOLDER"
  sudo apt-get update
  sudo apt-get install -y kubectl socat docker.io
fi

# install minikube
curl -Lo minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/


sudo -g docker minikube start  --v=7 --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --no-vtx-check --wait=false --driver=none