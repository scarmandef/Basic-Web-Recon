#!/bin/bash

HOST=$1
DIR=$HOST

if [ "$1" == "" ]
then
	echo
	echo "[!] Recon_Web Script By Scarman [!]"
	echo "[+] Coloque um host [+]"
	echo "[+] Normal Scan: ./recon.sh www.google.com [+]"
	echo "[+] Wordpress: ./recon.sh www.google.com wordpress [+]"
	echo "[+] Joomla: ./recon.sh www.google.com joomla [+]"


else


mkdir ~/Desktop/$DIR
cd ~/Desktop/$DIR

echo 
echo "[+] - Enuneração de portas e serviços no host $HOST - [+]"
echo "[#] - Executando Nmap - [#]"

#nmap -v -sV -sC -T4 -Pn $HOST -oA $HOST

if [ "$2" == "wordpress" ]
then
	wpscan --url $HOST
fi

if [ "$2" == "joomla" ]
then
	cd /opt/recon/joomscan && perl joomscan.pl -u $HOST
fi
	
echo
echo "[+] - Enumeração de diretórios $HOST - [+]"
echo "[#] - Executando Dirsearch - [#]"
cd /opt/recon/dirsearch && python3 dirsearch.py -mc 200,301,302 -u $HOST -w /opt/recon/ffuf/wordlists/directoryM.txt >> ~/Desktop/$DIR/dirsearch.txt | cd /opt/recon/dirsearch && python3 dirsearch.py -mc 200,301,302 -u $HOST -w /opt/recon/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt

echo "[#] - Executando Wayback - [#]"
cd /opt/recon/wayback && python3 waybackurls.py $HOST 
cd ~/Desktop/$DIR && mkdir wayback
grep -Poi '\["\K.*?(?=")' $HOST"-waybackurls.json"  >> ~/Desktop/$DIR/Wayback/"$HOST.txt"


echo "[#] - Executando Dirb - [#]"
dirb "https://"$HOST /opt/recon/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt >> ~/Desktop/$DIR/dirb.txt | dirb "https://"$HOST /opt/recon/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt

echo "[#] - Executando Ffuf para Diretórios - [#]"
cd /opt/recon/ffuf/ && ./ffuf -w /opt/recon/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt -u "$HOST/FUZZ" >> ~/Desktop/$DIR/ffufdir.txt | cd /opt/recon/ffuf/ && ./ffuf -w /opt/recon/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt

echo "[#] - Executando Ffuf para Arquivos no diretório / - [#]"
cd /opt/recon/ffuf/ && ./ffuf -w /opt/recon/SecLists-master/Discovery/Web-Content/raft-large-files.txt -u "$HOST/FUZZ" >> ~/Desktop/$DIR/ffuffiles.txt | cd /opt/recon/ffuf/ && ./ffuf -w /opt/recon/SecLists-master/Discovery/Web-Content/raft-large-files.txt -u "$HOST/FUZZ"


echo "[#] - Executando Reconftw - [#]"
cd /opt/recon/reconftw/ && bash reconftw.sh -d $HOST

echo "[#] - Executando Osmedeus - [#]"
cd /opt/recon/Osmedeus/ && python3 osmedeus.py -t $HOST


fi