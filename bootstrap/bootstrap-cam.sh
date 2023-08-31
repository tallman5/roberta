#!/bin/sh


cd ~


sudo apt update && sudo apt upgrade -y


echo -e "\e[32mInstalling git...\e[0m"
sudo apt install -y git


echo -e "\e[32mFix for missing /dev/serial/by-id...\e[0m"
sudo cp /usr/lib/udev/rules.d/60-serial.rules /usr/lib/udev/rules.d/60-serial.old
sudo wget -O /usr/lib/udev/rules.d/60-serial.rules https://raw.githubusercontent.com/systemd/systemd/main/rules.d/60-serial.rules


echo -e "\e[32mInstalling ustreamer...\e[0m"
sudo apt install -y libjpeg-dev libevent-dev libbsd-dev nlohmann-json3-dev libwebsockets-dev
git clone --depth=1 https://github.com/pikvm/ustreamer
cd ustreamer/
make
cd ~


echo -e "\e[32mConfiguring ustreamer service...\e[0m"
sudo useradd -r ustreamer
sudo usermod -a -G video ustreamer
sudo cp ~/bootstrap/ustreamer@.service /etc/systemd/system/ustreamer@.service
sudo systemctl enable ustreamer@.service
sudo systemctl enable ustreamer@0.service


echo -e "\e[32mInstalling snapd...\e[0m"
sudo apt install snapd -y
sudo snap install core


echo -e "\e[32mInstalling certbot...\e[0m"
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone
sudo certbot renew --dry-run


echo -e "\e[32mCopying certs...\e[0m"
mkdir certs
mkdir certs/rofo
sudo cp /etc/letsencrypt/live/rofo.mcgurkin.net/fullchain.pem ~/certs/rofo/
sudo cp /etc/letsencrypt/live/rofo.mcgurkin.net/privkey.pem ~/certs/rofo/
cd ~/certs/rofo
sudo chmod +r fullchain.pem
sudo chmod +r privkey.pem


echo -e "\e[32mInstalling nginx...\e[0m"
sudo apt-get install nginx -y
sudo cp ~/bootstrap/ustreamer-proxy /etc/nginx/sites-available/ustreamer-proxy
sudo ln -s /etc/nginx/sites-available/ustreamer-proxy /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx


echo -e "\e[32mRebooting...\e[0m"
sudo reboot now