#!/bin/bash

# sed -i "s/localhost/`dig +short myip.opendns.com @resolver1.opendns.com`/g" /installer/vars/default.yml
sed -i "s/localhost/$1/g" /installer/vars/default.yml

ansible-playbook /installer/local_install/local.yml
