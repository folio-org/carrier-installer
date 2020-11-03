#!/bin/bash

if [[ $1 == "def" ]]; then
  sed -i "s#localhost#`dig +short myip.opendns.com @resolver1.opendns.com`#g" /installer/vars/default.yml
  ansible-playbook /installer/local_install/local.yml | tee /installer/static/status
elif [[ $1 == "http" ]]; then
  sed -i "s#localhost#$2#g" /installer/vars/default.yml
  sed -i "s#/opt#$3#g" /installer/vars/default.yml
  sed -i "s#REDIS_PASSWORD: password#REDIS_PASSWORD: $4#g" /installer/vars/default.yml
  sed -i "s#INFLUX_PASSWORD: password#INFLUX_PASSWORD: $5#g" /installer/vars/default.yml
  sed -i "s#INFLUX_USERNAME: password#INFLUX_USERNAME: $6#g" /installer/vars/default.yml
  sed -i "s#password: password#password: $5#g" /installer/grafana/datasources/gatling.yaml
  sed -i "s#user: admin#user: $6#g" /installer/grafana/datasources/gatling.yaml
  sed -i "s#password: password#password: $5#g" /installer/grafana/datasources/jmeter.yaml
  sed -i "s#user: admin#user: $6#g" /installer/grafana/datasources/jmeter.yaml
  sed -i "s#password: password#password: $5#g" /installer/grafana/datasources/telegraf.yaml
  sed -i "s#user: admin#user: $6#g" /installer/grafana/datasources/telegraf.yaml
  ansible-playbook /installer/local_install/local.yml | tee /installer/static/status
else
  sed -i "s#localhost#$2#g" /installer/vars/default.yml
  sed -i "s#/opt#$3#g" /installer/vars/default.yml
  sed -i "s#REDIS_PASSWORD: password#REDIS_PASSWORD: $4#g" /installer/vars/default.yml
  sed -i "s#INFLUX_PASSWORD: password#INFLUX_PASSWORD: $5#g" /installer/vars/default.yml
  sed -i "s#INFLUX_USERNAME: password#INFLUX_USERNAME: $6#g" /installer/vars/default.yml
  sed -i "s#password: password#password: $5#g" /installer/grafana/datasources/gatling.yaml
  sed -i "s#user: admin#user: $6#g" /installer/grafana/datasources/gatling.yaml
  sed -i "s#password: password#password: $5#g" /installer/grafana/datasources/jmeter.yaml
  sed -i "s#user: admin#user: $6#g" /installer/grafana/datasources/jmeter.yaml
  sed -i "s#password: password#password: $5#g" /installer/grafana/datasources/telegraf.yaml
  sed -i "s#user: admin#user: $6#g" /installer/grafana/datasources/telegraf.yaml
  sed -i "s#admin@example.com#$7#g" /installer/carrier-ssl/traefik/traefik.toml
  ansible-playbook /installer/local_install/localssl.yml | tee /installer/static/status
fi

echo "________________________________________________________________________________________" >> /installer/static/status ; echo " Installation is Complete " >> /installer/static/status
