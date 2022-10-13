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

CMD npm start --prefix /srv/flood/