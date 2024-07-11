#!/bin/bash

git pull
cd ansible
# ansible-playbook ./setup.yml
ansible-playbook ./setup_playbook.yml
cd ..