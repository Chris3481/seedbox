FROM debian:12

ARG USERNAME=rtorrent
ENV USER_UID=$USER_UID
ENV USER_GID=$USER_GID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && usermod -aG root $USERNAME

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