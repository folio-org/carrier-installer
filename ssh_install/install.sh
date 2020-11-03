#!/bin/bash

chmod 400 /installer/ssh_install/id_rsa
sed -i "s#localhost#$1#g" /installer/vars/default.yml
cat << EOF > /installer/ssh_install/mysshhost
[myhost]
$1 ansible_user=$2 ansible_ssh_private_key_file=/installer/ssh_install/id_rsa ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
EOF
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
ansible-playbook /installer/carrierbook.yml -i /installer/ssh_install/mysshhost
