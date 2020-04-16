# /bin/bash

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


PublicIP=$(curl --silent ifconfig.me)
echo "Public IP: $PublicIP"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $PublicIP" sh -s -
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo sed -i "s/127\.0\.0\.1/$PublicIP/g" ~/.kube/config
sudo chmod 755 ~/.kube/config
sudo chmod 755 /etc/rancher/k3s/k3s.yaml
echo "Done!"

# dashboard
# GITHUB_URL=https://github.com/kubernetes/dashboard/releases
# VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
# sudo k3s kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml


# sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config