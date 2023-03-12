FROM node:14

RUN apt-get update && \
        apt-get install -y \
        git \
        && rm -rf /var/lib/apt/lists/*

# install flood
RUN cd /srv && git clone https://github.com/jfurrow/flood.git && \
    cd /srv/flood && cp config.template.js config.js

RUN cd /srv/flood && \
     npm install && \
     npm run build

CMD npx --prefix /srv/flood/ flood start -h 0.0.0.0 -d /data/flood-db