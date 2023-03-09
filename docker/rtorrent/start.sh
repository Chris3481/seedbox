#!/bin/bash


if [ $ENABLE_VPN == 'true' ]; then

  while ! ifconfig -s | grep tun0; do
      echo "Waiting for vpn connexion"
      sleep 1
  done
fi


VPN_IP=$(curl ifconfig.me)

echo "bind rtorrent on IP $VPN_IP"

/usr/bin/rtorrent -o import=/srv/rtorrent/.rtorrent.rc -b 0.0.0.0 -i $VPN_IP