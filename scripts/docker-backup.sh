#!/usr/bin/env bash

APPDATA_LOC="/mnt/docker"
BACKUP_LOC="/mnt/backup/docker"
COMPOSE_LOC="/mnt/ansible/docker-compose.yml"

date=$(date -I)
hostname=$(hostname -s)
archive="$(date '+%Y-%m-%d')"


function update {
    echo "Searching for yq"
    if which yq; then
        echo "yq found, continuing"
    else
        echo "Please install yq first"
        exit 1
    fi

    sudo docker compose -f "$COMPOSE_LOC" pull
    docker compose -f "$COMPOSE_LOC" down

    echo "Starting backup"
    mkdir -p "$BACKUP_LOC/$hostname/$archive" "$BACKUP_LOC/$hostname/latest"
    cp -a "$COMPOSE_LOC" $BACKUP_LOC/$hostname/$archive/docker-compose.yml.bak
    sudo tar -czf $BACKUP_LOC/$hostname/$archive/appdatabackup.tar.gz $APPDATA_LOC

    cp -a "$COMPOSE_LOC" $BACKUP_LOC/$hostname/$archive/docker-compose.yml.bak
    sudo tar -czf $BACKUP_LOC/$hostname/latest/appdatabackup.tar.gz $APPDATA_LOC

    docker compose -f "$COMPOSE_LOC" up -d
    sudo chown "${USER}":"${USER}" -R $BACKUP_LOC/$hostname/$archive/appdatabackup.tar.gz

    docker image prune -f

    echo "Backup finished"
}

function restore {
    sudo docker compose -f "$COMPOSE_LOC" down
    randstr=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};echo;)
    sudo mv "$APPDATA_LOC" "${APPDATA_LOC}.$randstr"
    sudo cp -a "$COMPOSE_LOC" "${COMPOSE_LOC}.$randstr"
    sudo mkdir -p "$APPDATA_LOC"
    sudo tar -xvf $BACKUP_LOC/$hostname/latest/appdatabackup.tar.gz $APPDATA_LOC
    sudo chown "${USER}":"${USER}" -R "$APPDATA_LOC"
    sudo chmod 770 -R "$APPDATA_LOC"
    docker compose -f "$COMPOSE_LOC" pull
    docker compose -f "$COMPOSE_LOC" up -d
}

# Check if the function exists
if declare -f "$1" > /dev/null; then
  "$@"
else
  echo "The only valid arguments are update, restore, and resume"
  exit 1
fi