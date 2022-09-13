FROM buildpack-deps:bullseye

RUN apt-get update && \
        apt-get install -y \
        rtorrent \
        && rm -rf /var/lib/apt/lists/*

COPY .rtorrent.rc /srv/rtorrent/.rtorrent.rc

CMD /usr/bin/rtorrent -o import=/srv/rtorrent/.rtorrent.rc