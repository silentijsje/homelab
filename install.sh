#!/bin/bash

git pull
cd ansible
ansible-playbook ./setup.yml
cd ..