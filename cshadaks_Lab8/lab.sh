#!/bin/bash

# Check if iptables is installed
if ! command -v iptables &> /dev/null
then
    # Install iptables
    echo "iptables is not installed. Installing..."
    # You may need to modify the package manager based on your distribution (e.g., apt for Debian/Ubuntu, yum for CentOS)
    apt-get update
    apt-get install -y iptables
    # Add other package manager commands as needed
fi

# Prompt the user to enter a folder name
read -p "Enter the folder name: " folder_name

# Ensure the folder exists or create it
mkdir -p "/root/$folder_name"


# Execute iptables commands for each section
# 0th iptable
iptables -L
iptables-save > "/root/$folder_name/iptables0.txt"

# 1st
iptables -A INPUT -p icmp -j DROP
iptables -A OUTPUT -p icmp -j DROP
iptables -L
iptables-save > "/root/$folder_name/iptables1.txt"
ping indiana.edu

# 2nd
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p udp -j DROP
iptables -A OUTPUT -p udp -j DROP
iptables -L
iptables-save > "/root/$folder_name/iptables2.txt"
dig indiana.edu

# 3rd
Luddy_Server_IP1="129.79.123.142"
Luddy_Server_IP2="129.79.123.143"
iptables -A OUTPUT -p tcp --dport 80 -d $Luddy_Server_IP1 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -d $Luddy_Server_IP2 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -d $Luddy_Server_IP1 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -d $Luddy_Server_IP2 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j DROP
iptables -A OUTPUT -p tcp --dport 443 -j DROP
iptables -L
iptables-save > "/root/$folder_name/iptables3.txt"
wget http://www.google.com
root@i520-server:~# wget http://luddy.indiana.edu

# 4th
iptables -A INPUT -p tcp --sport 80 -s 192.168.122.188 -j ACCEPT
iptables -A INPUT -p tcp --sport 80 -s 192.168.122.183 -j DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --sport 80 -j DROP
iptables -L
iptables-save > "/root/$folder_name/iptables4.txt"
wget http://192.168.122.183

# 5th
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -j DROP
iptables -L
iptables-save > "/root/$folder_name/iptables5.txt"

echo "Iptables configurations have been applied and saved in /root/$folder_name folder."

# Zip the folder
zip -r "/root/$folder_name.zip" "/root/$folder_name"

# Move the zip file to /home/sadmin/
mv "/root/$folder_name.zip" "/home/sadmin/"

echo "use this command in exouser"
echo "sudo scp -r sadmin@192.168.122.183:/home/sadmin/$foldername/ ."

#part1
# Check if Snort is installed
if ! command -v snort &> /dev/null
then
    # Install Snort
    echo "Snort is not installed. Installing..."
    apt-get update
    apt-get install -y snort
    # Add other package manager commands as needed
fi


# Ask the user to enter a new name for .rules files
read -p "Enter a new name for Snort .rules files (without extension): " snort_rules_name

# Create a new Snort .rules file based on user input
rules_file="/etc/snort/rules/$snort_rules_name.rules"
echo "alert tcp any any -> 192.168.122.183 22 (msg:\"SSH attempt from specific IP\"; sid:1;)" > "$rules_file"
echo "alert tcp any any -> 192.168.122.183 80 (msg: \"HTTP request to server\"; sid:2;)" >> "$rules_file"
echo "alert tcp 1.1.1.1 1024 -> 2.2.2.2 2048 (flags: F; msg:\"Syn Alert\"; sid:3;)" >> "$rules_file"
echo "alert ip 192.168.1.100 any -> 192.168.122.183 any (msg:\"Traffic from 192.168.1.100\"; sid:4;)" >> "$rules_file"
echo "alert tcp 192.168.122.183 any -> 157.240.192.0/18 any (msg:\"connection to Facebook detected\";sid:5;)" >> "$rules_file"
echo "alert tcp any any -> 192.168.122.183 1000:1010 (msg:\"Port Scan Attempt\"; flags:S; sid:9;)" >> "$rules_file"

# Open the Snort rules file with vim
vim "$rules_file"

vim /etc/snort/snort.conf

#snort restart
sudo service snort restart












