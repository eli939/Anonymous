#!/bin/bash

#Hello, this is my 3nd project.
#student name: Tal Cohen ,S21. Cyber security 773630. Annonymous.

#3.1 Save the Whois and Nmap data into files on the local computer.
#3.2 Create a log and audit your data collecting.
#3.1 Save the Whois and Nmap data into files on the local computer.
cd /var/log
log_file="/var/log"
function save_to_log ()
{
    echo "$(date) $1" >> script_file
}
#1.1 Install the needed applications to remain anonymous
#2 If the applications are already installed, don’t install them again.
echo
echo "Hello, this is a script to scan anonymosly via ssh an ip address."
sleep 1
echo "All the data will be saved in a spaciel log created during the running of the script."
echo "you will find the log inside /var/log directories." 
echo "In addition, inforamtion about the ip target will be saved on your current directory"
sleep 1
echo 
echo "Checking if the relevant apps are installed:"
sleep 1
echo "."
sleep 1
echo ".."
sleep 1 
echo "..."
sleep 1
function is_the_apps_install ()
{

if ! command -v "$geoip-bin" &> /dev/null 
then  
        echo "-> 'Geo-bin' is ready "
else  
        echo "Geo-bin is NOT install. installing it now..." >> save_to_log 
        echo "sudo apt-get install geoip-bin -y"
fi

sleep 2

if ! command -v anonsurf &> /dev/null
then 
    echo "AnonSurf is NOT installed. Installing AnonSurf..."
    sudo apt-get update
    sudo apt-get install -y anonsurf
else
    echo "-> 'AnonSurf' is ready" 
fi

sleep 2

if dpkg -l | grep -q sshpass
# DPKG cheaking inside the installed packets the sshpass packet. if it's found then.... 

then 
	echo "-> 'Sshpass' is ready "
else 
	echo "'sshpass' is NOT installed. installing now..." >> save_to_log
	sudo apt-get install -y sshpass
	sudo apt-get install openssh-client
fi
}
is_the_apps_install 


sleep 2

#3 Check if the network connection is anonymous; if not, alert the user and exit.
#1.4 If the network connection is anonymous, display the spoofed country name.
echo
echo "checking for Anonymity"
sleep 1
echo "."
sleep 1
echo ".."
sleep 1
echo "..."
sleep 1
# i chose to use anonsurf after using nipe, because nipe have lots of issues while running
#acording to AI - the line /dev/null- present anonsurf without its instractions
sudo anonsurf start > /dev/null 2>&1
echo "turning on AnonSurf. stand by..."
echo "$(date) - Turning on AnonSurf" >> save_to_log
sleep 1 
function anonymous
{
ip=$(curl -s https://ipapi.co/ip/)
country=$(curl -s https://ipapi.co/$ip/country_name/)
if [ -z "$country" ]
then
        country="Unknown"
fi
if [ "$country" == "IL" ] || [ "$country" == "Israel" ]
then
        echo "you are NOT anonymous, therefor exiting..."
        exit
else
        echo "you are anonymous, you may continue:"
	echo "Your spoofed country is $country"
fi
}
anonymous
echo
echo "looks like everything is ready for you to scan anonymosly"
#1.5 Allow the user to specify the address to scan via remote server; save into a variable.
function ssh_connect {
sleep 0.5
echo "please enter an IPv4 address you would like to scan"
read ip
echo "please enter a username"
read user
echo "please enter a password" 
read -s pass


sshpass -p "$pass" ssh -t -o StrictHostKeyCheaking=no -o Loglevel=ERROR -o UserKnownHostsFile=/dev/null "$user@$ip" "uptime" > /dev/null 2>&1
echo "$(date) - connection to ssh" >> save_to_log
}
ssh_connect
echo

#2.1 Display the details of the remote server (country, IP, and Uptime).
sshpass -p "$pass" ssh -t -o StrictHostKeyChecking=no -o LogLevel=ERROR -o UserknownHostsFile=/dev/null "$user@$ip" << 'EOF'
        remote_ip=$(curl -s ifconfig.co)
        country=$(curl -s https://ipapi.co/$remote_ip/country_name/)
            echo "The IP address is: $remote_ip"
            echo "The country is: $country"
            echo "Uptime: $(uptime)"
EOF

#2.2 Get the remote server to check the Whois of the given address.
echo "information from whois of the ip address '$ip'"
timestamp=$(date +"%Y%m%d_%H%M%S")
script_file="scan_info_${timestamp}.txt"
whois "$ip" >> script_file

#2.3 Get the remote server to scan for open ports on the given address.
echo
echo "open ports of the ip address '$ip'"
nmap -p- "$ip" >> script_file
echo "the scaning is complete and saved to the file 'script_info' inside /var/log"

