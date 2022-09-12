FROM buildpack-deps:bullseye

RUN apt-get update && \
        apt-get install -y \
        rtorrent \
        supervisor \
        && rm -rf /var/lib/apt/lists/*

CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
