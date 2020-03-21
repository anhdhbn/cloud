# /bin/bash
sudo apt-get update

# install docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

# install kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# run minikube
sudo minikube start --driver=none --v=7 --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus 1


