#!/usr/bin/env bash

APPDATA_LOC="/mnt/docker"
BACKUP_LOC="/mnt/backup/docker"
COMPOSE_LOC="/mnt/ansible/docker-compose.yml"

date=$(date -I)
hostname=$(hostname -s)
archive="$(date '+%Y-%m-%d')"


function update {
  # echo "Searching for yq"
  # if which yq; then
  #   echo "yq found, continuing"
  # else
  #   echo "Please install yq first"
  #   exit 1
  # fi

  sudo docker compose -f "$COMPOSE_LOC" pull
  docker compose -f "$COMPOSE_LOC" down

  echo "Starting backup"
  APPDATA_NAME=$(echo "$APPDATA_LOC" | awk -F/ '{print $NF}')
  mkdir -p "$BACKUP_LOC/$hostname/$archive" "$BACKUP_LOC/$hostname/latest"

  cp -a "$COMPOSE_LOC" $BACKUP_LOC/$hostname/latest/docker-compose.yml.bak
  sudo tar -C "$APPDATA_LOC"/.. -czf $BACKUP_LOC/$hostname/latest/appdatabackup.tar.gz "$APPDATA_NAME"
  cp -a $BACKUP_LOC/$hostname/latest/* $BACKUP_LOC/$hostname/$archive/

  docker compose -f "$COMPOSE_LOC" up -d
  sudo chown "${USER}":"${USER}" -R $BACKUP_LOC/$hostname/

  docker image prune -f
  cleanup_old_backups
}

function cleanup_old_backups {
  echo "Cleaning up old backups"
  backup_dirs=($(ls -dt $BACKUP_LOC/$hostname/*/ | grep -v "latest"))
  if [ ${#backup_dirs[@]} -gt 10 ]; then
    dirs_to_delete=(${backup_dirs[@]:10})
    for dir in "${dirs_to_delete[@]}"; do
      echo "Deleting old backup: $dir"
      rm -rf "$dir"
    done
  fi
}

function restore {
  sudo docker compose -f "$COMPOSE_LOC" down
  randstr=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};echo;)
  sudo mv "$APPDATA_LOC" "${APPDATA_LOC}.$randstr"
  sudo cp -a "$COMPOSE_LOC" "${COMPOSE_LOC}.$randstr"
  sudo mkdir -p "$APPDATA_LOC"
  cp -a $BACKUP_LOC/$hostname/latest/docker-compose.yml.bak "$COMPOSE_LOC"
  sudo tar -xf $BACKUP_LOC/$hostname/latest/appdatabackup.tar.gz -C "$APPDATA_LOC"/../
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