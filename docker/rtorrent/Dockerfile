FROM buildpack-deps:bullseye

ARG USERNAME=rtorrent
ENV USER_UID=1000
ENV USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN apt-get update && \
        apt-get install -y \
        rtorrent \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir "/srv/rtorrent"

COPY .rtorrent.rc /srv/rtorrent/.rtorrent.rc

RUN chown -R $USER_UID:$USER_GID /srv/rtorrent

USER $USERNAME

CMD /usr/bin/rtorrent -o import=/srv/rtorrent/.rtorrent.rc -b 0.0.0.0 -i 82.64.237.77