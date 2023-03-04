# Seedbox

Docker based seedbox and personnal media server compatible with raspery pi arm64 architecture

All what you need is a clean and fresh docker setup

---

### ✨ Main features

- **Modern web UI to manage torrents**

Includes [flood modern UI](https://flood.js.org/)  for torrent management. Enjoy a smooth, awesome experience on any device.

- **rTorrent optimized configuration**

It's important to be able to share files you download in order to have a good ratio on your favorite torrent tracker.

-  **Open vpn support**

A real self-hosted seedbox needs to guarantee anonymity. All services could use openvpn to hide you ip address

- **Web browser file explorer**

Access download and share all your files over internet in a modern web browser UI based on [filebrowser](https://filebrowser.org/features)

- **UpNp media server**

Stream your content on you local network directly with VLC media player or with any device compatible with up the UpNp protocol

-  **Samba file server**

Mount your seedbox download folder on any Windows or Linux computer

---

### 🛠️ Installation

Clone the project : `git clone https://github.com/Chris3481/seedbox.git` 

Create your .env file : `cp .env.example .env` 

Run `./seedbox.sh run`