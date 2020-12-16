#!/bin/bash

echo -e "\nEnabling IPV4 Packet Forwarding"

# Enable IP V4 Packet Routing
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf > /dev/null
sudo sysctl -p > /dev/null

echo -e "\nSetting static IP Address on Ethernet Port"

# Ethernet static IP
echo 'interface eth0' | sudo tee -a /etc/dhcpcd.conf > /dev/null
echo 'static ip_address=192.168.200.1/24' | sudo tee -a /etc/dhcpcd.conf > /dev/null
echo 'noipv6' | sudo tee -a /etc/dhcpcd.conf > /dev/null

# stop and restart eth0 network interface
sudo ip link set eth0 down && sudo ip link set eth0 up 
sleep 10

echo -e "\nEnabling Packet Routing"

# enable Ethernet to WiFi traffic routing
sudo iptables -t nat -A POSTROUTING -s 192.168.200.0/24 -o wlan0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo sed -i -e '$i \iptables-restore < /etc/iptables.ipv4.nat\n' /etc/rc.local

echo -e "\nDisabling WiFi Power Management"
# Disable WiFi power management
sudo sed -i -e '$i \iwconfig wlan0 power off\n' /etc/rc.local
sudo iwconfig wlan0 power off
