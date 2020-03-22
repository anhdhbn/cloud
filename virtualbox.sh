# /bin/bash
# install virtualbox
DEB_VIRTUALBOX="deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib"
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo add-apt-repository $DEB_VIRTUALBOX
if ! grep -q "$DEB_VIRTUALBOX" /etc/apt/sources.list ; then
  sudo add-apt-repository "$DEB_VIRTUALBOX"
fi
sudo apt update && sudo apt install -y virtualbox-6.0