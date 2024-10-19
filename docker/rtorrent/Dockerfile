FROM debian:12

ARG USERNAME=rtorrent
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID --groups root $USERNAME

RUN apt-get update && \
        apt-get install -y \
        rtorrent \
        curl \
        lsof \
        net-tools \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir "/srv/rtorrent" \
     && mkdir "/srv/rtorrent/download" \
     && mkdir "/srv/rtorrent/log"

COPY .rtorrent.rc /srv/rtorrent/.rtorrent.rc
COPY start.sh /srv/rtorrent/start.sh

RUN chown -R $USER_UID:$USER_GID /srv/rtorrent \
    && chmod +x /srv/rtorrent/start.sh

USER $USERNAME

CMD /srv/rtorrent/start.sh