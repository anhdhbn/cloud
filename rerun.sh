# /bin/bash
sudo systemctl start kubelet
sudo minikube start --driver=none --v=7 --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus 1