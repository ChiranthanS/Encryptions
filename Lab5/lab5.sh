#!/bin/bash

#sudo su -

echo "Create main CA folder"
ssh sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S mkdir -p /opt/CA"

echo "List of folder names to create"
folder_names=("newcerts" "private" "certs" "reqs")

echo "SSH command to create the folders on the sadmin machine"
for folder_name in "${folder_names[@]}"; do
  ssh sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S mkdir -p /opt/CA/$folder_name"
done

echo "SSH command to create the 'serial' file with '01' as its content"
ssh sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S sh -c 'echo 01 > /opt/CA/serial'"

echo "SSH command to create the 'database.txt' file"
ssh sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S touch /opt/CA/database.txt"

echo "SSH command to copy openssl.cnf to /opt/CA/caconfig.cnf"
ssh sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S cp /usr/lib/ssl/openssl.cnf /opt/CA/caconfig.cnf"

echo "First changes like in region, place ect"
ssh -t sadmin@192.168.122.183 "sudo vim /opt/CA/caconfig.cnf"

echo " SSH command to set the OPENSSL_CONF environment variable"
ssh sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S sh -c 'export OPENSSL_CONF=/opt/CA/caconfig.cnf'"

echo "SSH command to run the openssl req command inside /opt/CA"
ssh -t sadmin@192.168.122.183 "sudo -S sh -c 'cd /opt/CA && openssl req -x509 -newkey rsa:2048 -out /opt/CA/cacert.pem -outform PEM -days 60'"


echo "SSH command to run openssl req inside the cadmin machine"
ssh -t cadmin@192.168.122.188 "openssl req -new -newkey rsa:2048 -nodes -keyout clientkey.key -out clientreq.csr"

scp cadmin@client:~/clientreq.csr ./
scp clientreq.csr sadmin@server:~/

echo "SSH command to move the clientreq.csr file to /opt/CA/reqs/ with sudo"
ssh  sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S mv ~sadmin/clientreq.csr /opt/CA/reqs/"

echo "SSH command to copy the privkey.pem file to /opt/CA/private/ with sudo"
ssh  sadmin@192.168.122.183 "echo 'Lindley_026Lab' | sudo -S cp /opt/CA/privkey.pem /opt/CA/private/cakey.pem"

echo "SSH command to run openssl ca with sudo"
ssh -t sadmin@192.168.122.183 "sudo -S openssl ca -out /opt/CA/certs/192.168.122.188.pem -config /opt/CA/caconfig.cnf -infiles /opt/CA/reqs/clientreq.csr"

echo "SOME SCP is done here"
scp sadmin@server:/opt/CA/cacert.pem ./
scp sadmin@server:/opt/CA/certs/192.168.122.188.pem ./
scp 192.168.122.188.pem cadmin@client:~/
scp cacert.pem cadmin@client:~/

echo "SSH command to run a2enmod ssl with sudo in the cadmin machine"
ssh -t cadmin@192.168.122.188 "sudo -S a2enmod ssl"


echo "SSH commands to copy the files with sudo in the cadmin machine"
ssh cadmin@192.168.122.188 "echo 'Lindley_026Lab' | sudo -S cp cacert.pem /etc/ssl/"
ssh cadmin@192.168.122.188 "echo 'Lindley_026Lab' | sudo -S cp cacert.pem /etc/ssl/certs/"
ssh cadmin@192.168.122.188 "echo 'Lindley_026Lab' | sudo -S cp 192.168.122.188.pem /etc/ssl/certs/"
ssh cadmin@192.168.122.188 "echo 'Lindley_026Lab' | sudo -S cp clientkey.key /etc/ssl/private/"


echo "SSH command to open the default-ssl.conf file in vim with sudo in the cadmin machine"
ssh -t cadmin@192.168.122.188 "sudo vim /etc/apache2/sites-available/default-ssl.conf"

echo " SSH command to run a2ensite with sudo in the cadmin machine"
ssh -t cadmin@192.168.122.188 "sudo -S a2ensite default-ssl.conf"

echo "SSH command to reload Apache in sudo mode in the cadmin machine"
