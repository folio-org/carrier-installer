#!/bin/bash

if [[ $1 == "def" ]]; then
  sed -i "s#localhost#`dig +short myip.opendns.com @resolver1.opendns.com`#g" /installer/vars/default.yml
else
  sed -i "s#localhost#$1#g" /installer/vars/default.yml
  sed -i "s#/opt#$2#g" /installer/vars/default.yml
  sed -i "s#password#$3#g" /installer/vars/default.yml
fi

ansible-playbook /installer/local_install/local.yml | tee /installer/static/status
echo "________________________________________________________________________________________" >> /installer/static/status ; echo " Installation is Complete " >> /installer/static/status
