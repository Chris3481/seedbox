#!/bin/bash

# exit when any command fails
set -e

# Export env vars
export $(grep -v '^#' .env | xargs)

# Define existing services we can run
allowed_services=("all" "vpn" "seedbox" "media" "vpr")
allowed_torrent_clients=("rtorrent" "qbittorrent")

function boot() {

  init_docker_compose_files;

  case $1 in

    run)
      services=$2;
      run $services
      ;;

    stop)
      services=$2;
      stop $services
      ;;

    restart)
      services=$2;
      stop $services
      run $services
      ;;

    *)
      help
      ;;
  esac
}

# Start services
function run() {

  init_folders;

  if [[ $services == '' ]]; then
    services='all';
  fi

  $(validate_services $services);

  containers=$(get_containers $services);

  command=$(get_docker_compose_command);

  eval "${command} up -d ${containers}";
}

# Stop services
function stop() {

  if [[ $services == '' ]]; then
    services='all';
  fi

  $(validate_services $services);

  containers=$(get_containers $services);

  command=$(get_docker_compose_command);

  eval "${command} stop ${containers} && ${command} rm -f ${containers}";
}


 # Check if services is exists
function validate_services() {

  services_arr=$(echo $1 | tr "," "\n")

  for service in $services_arr
  do
    if [[ ! " ${allowed_services[*]} " =~ " ${service} " ]]; then
        echo "Unknown service [$service]"
        exit 1;
    fi
  done
}


function init_docker_compose_files() {

  COMPOSE_FILE="docker-seedbox-services.yml";
  COMPOSE_FILE="${COMPOSE_FILE}:docker-vpn-service.yml";
  COMPOSE_FILE="${COMPOSE_FILE}:docker-local-services.yml";
  COMPOSE_FILE="${COMPOSE_FILE}:docker-vpr-services.yml";

  export COMPOSE_FILE=$COMPOSE_FILE;
}

function get_containers() {

  # Check if torrent client exists
  if [[ ! " ${allowed_torrent_clients[*]} " =~ " $TORRENT_CLIENT " ]]; then
      echo "Unknown torrent client [$TORRENT_CLIENT]"
      exit 1;
  fi

  VPN_CONTAINERS='vpn';
  MEDIA_CONTAINERS='samba minidlna filebrowser';
  VPR_CONTAINERS='sonarr';
  SEEDBOX_VPN_CONTAINERS="flood-vpn $TORRENT_CLIENT-vpn";
  SEEDBOX_STANDALONE_CONTAINERS="flood-standalone $TORRENT_CLIENT-standalone";

  services_arr=$(echo $1 | tr "," "\n");

  CONTAINERS='';

  for service in $services_arr
  do
    # Check if services is exists
    if [[ ! " ${allowed_services[*]} " =~ " ${service} " ]]; then
        echo "Unknown service [$service]"
        exit;
    fi

    # Map service to docker-compose file
    if [[ $services == 'all' ]]; then

      if [[ $ENABLE_VPN == 'true' ]]; then
        CONTAINERS="${CONTAINERS} ${VPN_CONTAINERS} ${SEEDBOX_VPN_CONTAINERS} ${MEDIA_CONTAINERS} ${VPR_CONTAINERS}"
      else
        CONTAINERS="${CONTAINERS} ${SEEDBOX_STANDALONE_CONTAINERS} ${MEDIA_CONTAINERS} ${VPR_CONTAINERS}"
      fi
    fi

    if [ $service == "vpn" ] && [ $ENABLE_VPN == 'true' ]; then
       CONTAINERS="${CONTAINERS} ${VPN_CONTAINERS}";
    fi

    if [[ $service == "seedbox" ]]; then

      if [[ $ENABLE_VPN == 'true' ]]; then
        CONTAINERS="${CONTAINERS} ${VPN_CONTAINERS} ${SEEDBOX_VPN_CONTAINERS}"
      else
        CONTAINERS="${CONTAINERS} ${SEEDBOX_STANDALONE_CONTAINERS}"
      fi
    fi

    if [[ $service == "media" ]]; then
      CONTAINERS="${CONTAINERS} ${MEDIA_CONTAINERS}";
    fi

    if [[ $service == "vpr" ]]; then
          CONTAINERS="${CONTAINERS} ${VPR_CONTAINERS}";
        fi
  done

  echo $CONTAINERS;
}

function get_docker_compose_command() {

  if command -v docker-compose &> /dev/null
  then
      echo "docker-compose"
      exit
  fi

  if command -v docker compose &> /dev/null
    then
        echo "docker compose"
        exit
    fi

  echo "docker compose is not installed";

  exit 1;
}

function init_folders() {

  mkdir -p ${BASE_PATH}/data
  mkdir -p ${BASE_PATH}/data/filebrowser
  mkdir -p ${BASE_PATH}/data/rtorrent/sessions
  mkdir -p ${BASE_PATH}/logs
  mkdir -p ${BASE_PATH}/vpn
  mkdir -p ${DOWNLOAD_FOLDER_PATH}
}


function help() {

  # Display Help
cat <<EOF

  Manage seedbox services

  Syntax: seedbox [...option]
  options :
    run     [all|vpn|seedbox|local|vpr]      Run services         | comma separated list of services
    stop    [all|vpn|seedbox|local|vpr]      Stop all services    | comma separated list of services
    restart [all|vpn|seedbox|local|vpr]      Restart all services | comma separated list of services

EOF
}

boot $@;