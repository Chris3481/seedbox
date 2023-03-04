#!/bin/bash

# Export env vars
export $(grep -v '^#' .env | xargs)


# Define existing services we can run
allowed_services=("all" "vpn" "seedbox" "local")

function boot() {

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


function run() {

  init_folders;

  if [[ $services == '' ]]; then
    services='all';
  fi

  err=$(validate_services $services)
  if [[ $services != '' ]]; then
    echo $err;
  fi

  docker_compose_files=$(get_docker_compose_files_from_services $services);

  docker-compose $docker_compose_files up -d
}


function stop() {

  if [[ $services == '' ]]; then
    services='all';
  fi

    err=$(validate_services $services)
    if [[ $services != '' ]]; then
      echo $err;
    fi

  docker_compose_files=$(get_docker_compose_files_from_services $services);

  docker-compose $docker_compose_files down
}


 # Check if services is exists
function validate_services() {

  services_arr=$(echo $1 | tr "," "\n")

  for service in $services_arr
  do
    if [[ ! " ${allowed_services[*]} " =~ " ${service} " ]]; then
        echo "Unknown service [$service]"
        exit;
    fi
  done
}


function get_docker_compose_files_from_services() {

 services_arr=$(echo $1 | tr "," "\n")

  for service in $services_arr
  do
    # Check if services is exists
    if [[ ! " ${allowed_services[*]} " =~ " ${service} " ]]; then
        echo "Unknown service [$service]"
        exit;
    fi

    # Map service to docker-compose file
    if [[ $services == 'all' ]]; then
      docker_compose_files='-f docker-vpn-service.yml -f docker-seedbox-services.yml -f docker-local-services.yml ';
    fi

    if [[ $service == "vpn" ]]; then
      docker_compose_files="${docker_compose_files} -f docker-vpn-service.yml";
    fi

    if [[ $service == "seedbox" ]]; then
      docker_compose_files="${docker_compose_files} -f docker-seedbox-services.yml";
    fi

    if [[ $service == "local" ]]; then
      docker_compose_files="${docker_compose_files} -f docker-local-services.yml";
    fi
  done

  echo $docker_compose_files;
}

function init_folders() {

  mkdir -p ${BASE_PATH}/data
  mkdir -p ${BASE_PATH}/data/filebrowser/data
  mkdir -p ${BASE_PATH}/data/filebrowser/config
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
    run     [all|vpn|seedbox|local]      Run services         | comma separated list of services
    stop    [all|vpn|seedbox|local]      Stop all services    | comma separated list of services
    restart [all|vpn|seedbox|local]      Restart all services | comma separated list of services

EOF
}

boot $@;