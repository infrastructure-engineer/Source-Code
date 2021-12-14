 #!/bin/bash

#Script to Setup Ubuntu 18.04+

echo "Starting Setup..." 

#Install Firwall
sudo apt install -y ufw gufw

#Enable Firewall
sudo ufw enable

#Install Python 3.8
sudo apt install python3.8 python3.8-venv -y

#Install Python 3.8
# sudo apt-get install build-essential checkinstall -y
# sudo apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
# cd /opt
# sudo wget https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tgz
# sudo tar xzf Python-3.8.5.tgz
# cd Python-3.8.5
# sudo ./configure --enable-optimizations
# sudo make altinstall
# cd /opt
# sudo rm -f Python-3.8.5.tgz
# python3.8 -V


#Install NVIDIA Driver
wget -O ~/Downloads/NVIDIA-Linux-x86_64-450.66.run https://us.download.nvidia.com/XFree86/Linux-x86_64/450.66/NVIDIA-Linux-x86_64-450.66.run
sudo sh ~/Downloads/NVIDIA-Linux-x86_64-450.66.run

#Install NVIDIA CUDA Toolkit
wget -O /etc/apt/preferences.d/cuda-repository-pin-600 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt install cuda -y
echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.bashrc

#Install Python PIP
sudo apt install python-pip -y

#Install Git
sudo apt install git -y

#Install Github Desktop Gui
wget -qO - https://packagecloud.io/shiftkey/desktop/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/shiftkey/desktop/any/ any main" > /etc/apt/sources.list.d/packagecloud-shiftky-desktop.list'
sudo apt-get update
sudo apt install github-desktop -y

#Install Pycharm
sudo snap install pycharm-community --classic

#Install PowerShell 7
sudo snap install powershell --classic

#Install MS VSCode
sudo snap install code --classic

#Install Libre Office
sudo snap install libreoffice

#Install Flatpack Package Manger
sudo apt install flatpak -y
sudo apt install gnome-software-plugin-flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Install VLC
sudo apt-get install vlc -y

#Install Gimp Photo Editor
sudo apt-get install gimp -y

#Install Steam - Games
wget -O ~/Downloads/steam.deb https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo dpkg -i ~/Downloads/steam.deb

#Install Anti-Virus Scanner - Clam
sudo apt-get install clamtk clamav -y

#Install OBS Studio
sudo apt install ffmpeg -y
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo apt update
sudo apt install obs-studio -y

#KeepPass
sudo apt install keepass2 keepass2-doc -y

#Install Shortwave Internet Radio Player
flatpak install flathub de.haeckerfelix.Shortwave -y

#Install NordVPN
wget -O ~/Downloads/nordvpn-release_1.0.0_all.deb https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
sudo dpkg -i ~/Downloads/nordvpn-release_1.0.0_all.deb
sudo apt update
sudo apt install nordvpn

## NordVPN Note:
##Log in to your NordVPN account:
##nordvpn login

##Connect to a NordVPN server:
##nordvpn connect


#Install KVM Hyper-Visor
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager libguestfs-tools genisoimage virtinst -y 
LOCAL_INTERFACE=$(ip a | grep 192.168.0.)
echo "${LOCAL_INTERFACE##* }"
*still need completion
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu

#Setup Notepad++ (Wine)
sudo snap install notepad-plus-plus

echo "Completed Downloading Software..."

#Enable click to minimize
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'



#Clean Up Packgaes
sudo apt autoremove -y

#Claean Up Downloads Folder
rm -f ~/Downloads/*


#Install Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd && sudo shutdown -r now


#





