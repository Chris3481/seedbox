#!/bin/bash


while ! ifconfig -s | grep tun0; do
    echo "Waiting for vpn connexion"
    sleep 1
done

#VPN_IP=$(ifconfig tun0 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)

VPN_IP=$(curl ifconfig.me)


echo "bind rtorrent on IP $VPN_IP"

# echo "bind = $VPN_IP" >> /srv/rtorrent/.rtorrent.rc


echo "bind = 0.0.0.0" >> /srv/rtorrent/.rtorrent.rc


/usr/bin/rtorrent -o import=/srv/rtorrent/.rtorrent.rc -i $VPN_IP