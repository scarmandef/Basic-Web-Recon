#!/bin/bash

cd /opt/
sudo mkdir recon
sudo chmod 070 recon 
cd recon

sudo apt-get install -y dirb 
sudo apt-get install -y nmap
git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/maurosoria/dirsearch.git 
git clone https://github.com/OWASP/joomscan.git 
git clone https://github.com/six2dez/reconftw.git 
git clone https://github.com/ffuf/ffuf
git clone https://github.com/wpscanteam/wpscan.git
git clone https://github.com/j3ssie/Osmedeus.git 

sudo mkdir wayback
curl https://gist.githubusercontent.com/mhmdiaa/adf6bff70142e5091792841d4b372050/raw/56366e6f58f98a1788dfec31c68f77b04513519d/waybackurls.py -o /opt/recon/wayback/waybackurls.py

cd dirsearch
sudo chmod 070 *
cd ..

echo "[+] - Instalando ffuf - [+]"
cd ffuf ; go get ; go build
cd ..

echo "[+] - Instalando Osmedeus - [+]"
echo
cd Osmedeus
chmod +x install.sh 
./install.sh
cd ..

echo "[+] - Instalando Reconftw - [+]"
echo
cd reconftw
chmod +x install.sh
./install.sh
cd ..

echo "[+] - Instalando Wpscan - [+]"
cd wpscan
gem install wpscan

sudo chmod 070 *

