#!/bin/bash

git pull
cd ansible
ansible-galaxy install -p ~/github/homelab/ansible2/galaxy_roles -r galaxy_roles/galaxy.yml --force
cd ..