#!/usr/bin/env bash

cd /home/gamer0308/github/homelab_pub
git pull
build_version=$(git rev-parse --short HEAD)
echo "$(TZ='Europe/Amsterdam' date +%FT%T%z): Releasing new server version. $build_version" >> ~/github/homelab_pub/scripts/server.log
git commit -m 'Update server log' ~/github/homelab_pub/scripts/server.log
git push
echo "$(TZ='Europe/Amsterdam' date +%FT%T%z): Running build...."
./install.sh