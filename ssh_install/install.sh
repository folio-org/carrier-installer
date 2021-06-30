#!/bin/bash

chmod 400 /installer/ssh_install/id_rsa

cat << EOF > /installer/ssh_install/mysshhost
[myhost]
$1 ansible_user=$2 ansible_ssh_private_key_file=/installer/ssh_install/id_rsa ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
EOF
sed -i "s#/opt#$3#g" /installer/vars/default.yml
sed -i "s#REDIS_PASSWORD: password#REDIS_PASSWORD: $4#g" /installer/vars/default.yml
sed -i "s#INFLUX_PASSWORD: password#INFLUX_PASSWORD: $5#g" /installer/vars/default.yml
sed -i "s#INFLUX_USERNAME: admin#INFLUX_USERNAME: $6#g" /installer/vars/default.yml
sed -i "s#RABBIT_PASSWORD: password#RABBIT_PASSWORD: ${10}#g" /installer/vars/default.yml

if [[ $7 == "https"  ]]; then
 sed -i "s#localhost#$8#g" /installer/vars/default.yml
 sed -i "s#admin@example.com#$9#g" /installer/vars/default.yml
 ansible-playbook /installer/carrierbook.yml -i /installer/ssh_install/mysshhost | tee -a /installer/static/status
else
 sed -i "s#localhost#$1#g" /installer/vars/default.yml
 ansible-playbook /installer/carrierbookssl.yml -i /installer/ssh_install/mysshhost| tee -a /installer/static/status
fi

echo "________________________________________________________________________________________" >> /installer/static/status ; echo " Installation is Complete " >> /installer/static/status
