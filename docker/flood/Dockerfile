FROM node:14

RUN apt-get update && \
        apt-get install -y \
        git \
        jq \
        && rm -rf /var/lib/apt/lists/*

# install flood
RUN cd /srv && git clone https://github.com/jfurrow/flood.git && \
    cd /srv/flood && cp config.template.js config.js

RUN cd /srv/flood && \
     npm install && \
     npm run build

# Create the database directory if it doesn't exist
RUN mkdir -p /data/flood-db/db

# Copy the users.db file into the container
COPY ./users.db /data/flood-db/db

# Copy the entrypoint.sh script into the container
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint of the container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


# CMD npx --prefix /srv/flood/ flood start -h 0.0.0.0 -d /data/flood-db
