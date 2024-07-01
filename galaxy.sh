#!/bin/bash

git pull
cd ansible2
ansible-galaxy install -p ~/github/homelab/ansible2/galaxy_roles -r galaxy_roles/galaxy.yml --force
cd ..