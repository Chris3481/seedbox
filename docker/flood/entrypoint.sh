#!/bin/bash

# Function to start Flood
start_flood() {
  echo "Starting Flood..."
  npx --prefix /srv/flood/ flood start -h 0.0.0.0 -d /data/flood-db &
  echo "Waiting for Flood to start..."
  sleep 5
}

# Function for authentication and retrieving JWT
authenticate_flood() {

  JWT=$(curl -i -XPOST http://127.0.0.1:3000/api/auth/authenticate \
      -H 'Content-Type: application/json' \
      -d '{"username":"admin", "password":"dcb983c9-1dcd-4396-998c-891931ec252b"}' \
      | grep Set-Cookie \
      | grep -o 'jwt[^;]*')

  if [ -z "$JWT" ]; then
    echo "Error: Unable to retrieve JWT."
    exit 1
  fi

  # Return the JWT token
  echo "$JWT"
}

# Function to create a new user via API, using the environment variables from .env
create_user() {
  # Get the JWT by calling authenticate_flood
  JWT=$(authenticate_flood)

  echo "JWT token: $JWT"

  # Check if the necessary environment variables are set
  if [ -z "$FLOOD_ADMIN_USERNAME" ] || [ -z "$FLOOD_ADMIN_PASSWORD" ]; then
    echo "Error: FLOOD_ADMIN_USERNAME and FLOOD_ADMIN_PASSWORD must be set in .env."
    exit 1
  fi

  echo "Creating a new user with username: $FLOOD_ADMIN_USERNAME"

  # Create the JSON payload while escaping any special characters
  json_payload=$(jq -n \
    --arg username "$FLOOD_ADMIN_USERNAME" \
    --arg password "$FLOOD_ADMIN_PASSWORD" \
    '{
      username: $username,
      password: $password,
      client: {
        client: "rTorrent",
        type: "tcp",
        version: 1,
        host: "rtorrent-standalone",
        port: 16891
      },
      level: 10
    }')

  # Send the POST request with the JSON payload
  curl -XPOST http://127.0.0.1:3000/api/auth/register \
      -H 'Content-Type: application/json' \
      -H "cookie: $JWT" \
      -d "$json_payload"
}

# Main
start_flood
create_user

# Keep the Flood process active in the foreground
wait
