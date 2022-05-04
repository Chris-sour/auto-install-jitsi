#!/bin/bash
curl https://download.jitsi.org/jitsi-key.gpg.key | sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg' 
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
apt update
apt upgrade -y
apt install apt-transport-https mc curl gpg lsb-release -y
apt-get install -y dnsutils
ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
echo "**********************************************************"
echo "* JITSI MEET INSTALL *"
echo "* VPS, DEDICATED SERVERS, HOSTING *"
echo "* -- www.devchristiangonzales.com -- *"
echo "**********************************************************"
sleep 1
echo "Set Hostname enter hostname for Jitsi Meet example: meet.devchristian.com.pe"
read hostname
host=${hostname%.*.*.*}
echo $'127.0.0.1	localhost\n'$ip'	'$hostname'	'$host > /etc/hosts
hostnamectl set-hostname $host
echo "Checking that $hostname is pointed to $ip"
dnscheck=`dig +short A $hostname @8.8.8.8`
if [ ! "$dnscheck" = "$ip" ]
then
    echo "The DNS record does not exist, does not match the IP, or is not yet propagated in the DNS system"
    echo "Installation has been cancelled. Once the DNS record exists, run the installation again"
    exit 1
fi 
echo "The DNS record is looks good, installation will continue. You will have to enter it once again $hostname"
sleep 5
apt install jitsi-meet -y
#echo -e "example@example.com" | /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
echo "Installation complete. Please restart server."
sleep 1
