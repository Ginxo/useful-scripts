#!/bin/bash
# script to install the onedrive client, requires human intervention in one of the steps
# sources:
# https://www.maketecheasier.com/sync-onedrive-linux/
# https://www.modmy.com/how-sync-onedrive-linux

# libraries installation, choose ubuntu >=18.04, <18.04, fedora, or arch linux
# libraries installation: ubuntu 18.04
sudo apt install libcurl4-openssl-dev git
sudo apt install libsqlite3-dev
sudo snap install --classic dmd && sudo snap install --classic dub

# libraries installation: ubuntu <18.04
#sudo apt install libcurl4-openssl-dev git
#sudo apt install libsqlite3-dev
#sudo wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
#sudo apt-get update && sudo apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring
#sudo apt-get update && sudo apt-get install dmd-compiler dub

# libraries installation: Fedora
#sudo yum install libcurl-devel git
#sudo yum install sqlite-devel
#curl -fsS https://dlang.org/install.sh | bash -s dmd

# libraries installation: Arch Linux
#sudo pacman -S curl sqlite dlang git


# INSTALLATION
git clone https://github.com/skilion/onedrive.git
cd onedrive
make
sudo make install

# configuration
mkdir -p ~/.config/onedrive
cp config ~/.config/onedrive
# onedrive as a service
systemctl --user enable onedrive
systemctl --user start onedrive

# Starting up
# Once the client is executed you will have to copy/paste the link (if the browser is not open), signin into your Microsoft account and once you are in, copy the URL of the empty page that you are redirected to after signing in and paste it back to the terminal
onedrive

# You can check the onedrive status whenever you want executing the script
#journalctl --user-unit onedrive -f
