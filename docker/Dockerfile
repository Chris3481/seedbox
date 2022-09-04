FROM node:14

RUN apt-get update && \
        apt-get install -y \
        rtorrent \
        git \
        supervisor \
        ftp \
    	samba \
    	smbclient \
        && rm -rf /var/lib/apt/lists/*

# This causes a mount error, find why
# COPY rtorrent/.rtorrent.rc /srv/rtorrent

# install flood
RUN cd /srv && git clone https://github.com/jfurrow/flood.git && \
    cd /srv/flood && cp config.template.js config.js

RUN cd /srv/flood && \
     npm install && \
     npm run build

# start supervisord
CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

EXPOSE 3000
