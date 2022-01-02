apt update
apt upgrade
apt install iptables

wget https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh

chmod +x debian10-vpn.sh

APPROVE_INSTALL=y APPROVE_IP=y IPV6_SUPPORT=y PORT_CHOICE=1 PROTOCOL_CHOICE=1 DNS=3 COMPRESSION_ENABLED=n CUSTOMIZE_ENC=n CLIENT=Helium-Mango PASS=1 ./openvpn-install.sh


touch /etc/openvpn/ccd/Helium-Mango
touch /etc/openvpn/ccd/Helium-PC

echo ifconfig-push 10.8.0.2 255.255.255.0 > /etc/openvpn/ccd/Helium-Mango
echo ifconfig-push 10.8.0.4 255.255.255.0 > /etc/openvpn/ccd/Helium-PC

echo client-config-dir ccd >> /etc/openvpn/server.conf
echo route 192.168.8.0 255.255.255.0 >> /etc/openvpn/server.conf
echo push "route 192.168.8.0 255.255.255.0"  >> /etc/openvpn/server.conf
echo push "dhcp-option DNS 192.168.8.1" >> /etc/openvpn/server.conf

iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1240

iptables -A FORWARD -i tun0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

iptables -A FORWARD -i eth0 -o tun0 -p tcp --syn --dport 44158 -m conntrack --ctstate NEW -j ACCEPT

iptables -A FORWARD -i eth0 -o tun0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 44158 -j DNAT --to-destination 10.8.0.2

echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

sysctl -p

sudo apt-get install iptables-persistent

sudo netfilter-persistent save

sudo netfilter-persistent reload
