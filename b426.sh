#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'



# Function to enable IPv6 if disabled
enable_ipv6() {
    if [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6)" -eq 1 ]; then
        echo "Enabling IPv6..."
        sysctl -w net.ipv6.conf.all.disable_ipv6=0
        sysctl -w net.ipv6.conf.default.disable_ipv6=0
        echo "IPv6 enabled."
    else
        echo "IPv6 is already enabled."
    fi
}


configure_iran() {


 read -p "enter kharej ip V4:" ipv4kahrej
 echo -e "${yellow}yout kharej ip v4 is:${ipv4kahrej}${plain}"
 
 read -p "enter this  vps ip V4:" ipv4vps
 echo -e "${yellow}yout vps ip v4 is:${ipv4vps}${plain}"
 
  read -p "enter tunnel id:" tunnelid
 echo -e "${yellow}yout kharej ip v4 is:${tunnelid}${plain}"
 
 sudo ip tunnel del TUN${tunnelid}       
 sudo ip tunnel add TUN${tunnelid} mode sit remote ${ipv4kahrej} local ${ipv4vps} ttl 255 && sudo ip link set dev TUN${tunnelid} up && sudo ip addr add fc8${tunnelid}:1${tunnelid}a::1/64 dev TUN${tunnelid}  
 
 ip link add vxlan-${tunnelid} type vxlan id 50${tunnelid}1 remote fc8${tunnelid}:1${tunnelid}a::2 local fc8${tunnelid}:1${tunnelid}a::1 dev TUN${tunnelid}  dstport 4789

 ip addr add 163.100.1${tunnelid}.2/24 dev vxlan-${tunnelid} 
 
 ip link set up dev vxlan-${tunnelid}
 
 
#  cp /etc/rc.local /etc/rc.local.backup
 
#  echo  -e " sudo ip tunnel add TUN${tunnelid}  mode sit remote ${ipv4kahrej} local ${ipv4vps} ttl 255 && sudo ip link set dev TUN${tunnelid}  up && sudo ip addr add fc8${tunnelid}:1${tunnelid}a::1/64 dev TUN${tunnelid} " >> /etc/rc.local
#  echo  -e " ip link add vxlan-${tunnelid} type vxlan id 50${tunnelid}1 remote fc8${tunnelid}:1${tunnelid}a::2 local fc8${tunnelid}:1${tunnelid}a::1 dev TUN${tunnelid} dstport 4789" >> /etc/rc.local
#  echo  -e " ip addr add 163.100.1${tunnelid}.2/24 dev vxlan-${tunnelid} " >> /etc/rc.local
#  echo  -e " ip link set up dev vxlan-${tunnelid}" >> /etc/rc.local
 
 echo "done, please tunnel kharej"
 

}

configure_kharej() {


read -p "enter iran ip V4:" ipv4kahrej
 echo -e "${yellow}yout iran ip v4 is:${ipv4kahrej}${plain}"
 
 read -p "enter this  vps ip V4:" ipv4vps
 echo -e "${yellow}yout this ip v4 is:${ipv4vps}${plain}"
 
 read -p "enter tunnel id:" tunnelid
 echo -e "${yellow}yout tunnel id is:${tunnelid}${plain}"
 
 
 sudo ip tunnel del  TUN${tunnelid}     
 sudo ip tunnel add TUN${tunnelid} mode sit remote ${ipv4kahrej} local ${ipv4vps} ttl 255 && sudo ip link set dev TUN${tunnelid} up && sudo ip addr add fc8${tunnelid}:1${tunnelid}a::2/64 dev TUN${tunnelid} 
 
 ip link add vxlan-${tunnelid} type vxlan id 50${tunnelid}1 remote fc8${tunnelid}:1${tunnelid}a::1 local fc8${tunnelid}:1${tunnelid}a::2 dev TUN${tunnelid} dstport 4789

 ip addr add 163.100.1${tunnelid}.1/24 dev vxlan-${tunnelid}  
 
 ip link set up dev vxlan-${tunnelid} 

  echo "done, tunnel is ready"


}




# Ask the user which server to configure
read -p "Run configuration for iran 1 or kharej 2? (1/2): " server_choice

# Enable IPv6 if disabled
enable_ipv6

if [[ "$server_choice" == "1" ]]; then
    configure_iran
elif [[ "$server_choice" == "2" ]]; then
    configure_kharej
else
 echo "Invalid choice. Please run the script again and choose either 1 or 2."
fi
