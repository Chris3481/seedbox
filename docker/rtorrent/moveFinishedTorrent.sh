#!/bin/sh

LAST_ELEMENT=$(ls -Art /srv/rtorrent/download/ | tail -n 1)

echo $LAST_ELEMENT >> /srv/rtorrent/log/moveFinishedTorrent.log

cd /srv/rtorrent/download/

find "${LAST_ELEMENT}" -type f -exec curl --globoff --ftp-create-dirs -T {} ftp://192.168.0.254/Disque%20dur/Téléchargements/\{\} \;

exit
