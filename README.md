# Seedbox

Docker based seedbox services compatible with raspery pi arm64 architecture


## Main features

### Modern web UI to manage torrents.

Includes [flood modern UI](https://flood.js.org/)  for torrent management

Enjoy a smooth, awesome experience on any device.

### rTorrent optimized configuration

It's important to be able to share files you download in order to have a good ratio on your favorite torrent tracker.



### Web browser file explorer 

Access all your files over internet in a modern web browser UI based on [filebrowser](https://filebrowser.org/features)

- Manage you files 
- download all your files 
- share your files wih friends

### Open vpn support

A real self-hosted seedbox needs to guarantee anonymity. 

All services could use openvpn to hide you ip address 


## Installation

Clone the project : `git clone https://github.com/Chris3481/seedbox.git` 

Create your .env file : `cp .env.example .env` 

Run `./seedbox.sh run`