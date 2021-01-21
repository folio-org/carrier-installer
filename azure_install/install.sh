#!/bin/bash

sed -i "s/SELECTLOCATION/$1/g" /installer/azure_install/carrier.tf
sed -i "s/VMSELECT/$2/g" /installer/azure_install/carrier.tf

if [[ $3 == ubu1804 ]]; then
  sed -i 's#OSSELECTP#publisher = "Canonical"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTO#offer     = "UbuntuServer"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTS#sku       = "18.04-LTS"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTV#version   = "latest"#g' /installer/azure_install/carrier.tf
fi
if [[ $3 == ubu2004 ]]; then
  sed -i 's#OSSELECTP#publisher = "cognosys"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTO#offer     = "ubuntu-20-04-lts"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTS#sku       = "ubuntu-20-04-lts"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTV#version   = "1.0.3"#g' /installer/azure_install/carrier.tf
fi
if [[ $3 == centos75 ]]; then
  sed -i 's#OSSELECTP#publisher = "OpenLogic"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTO#offer     = "CentOS"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTS#sku       = "7.5"#g' /installer/azure_install/carrier.tf
  sed -i 's#OSSELECTV#version   = "latest"#g' /installer/azure_install/carrier.tf
fi
sed -i "s#/opt#$4#g" /installer/vars/default.yml
sed -i "s#REDIS_PASSWORD: password#REDIS_PASSWORD: $5#g" /installer/vars/default.yml
sed -i "s#INFLUX_PASSWORD: password#INFLUX_PASSWORD: $6#g" /installer/vars/default.yml
sed -i "s#INFLUX_USERNAME: admin#INFLUX_USERNAME: $7#g" /installer/vars/default.yml
sed -i "s#password: password#password: $6#g" /installer/grafana/datasources/gatling.yml
sed -i "s#user: admin#user: $7#g" /installer/grafana/datasources/gatling.yml
sed -i "s#password: password#password: $6#g" /installer/grafana/datasources/jmeter.yml
sed -i "s#user: admin#user: $7#g" /installer/grafana/datasources/jmeter.yml
sed -i "s#password: password#password: $6#g" /installer/grafana/datasources/telegraf.yml
sed -i "s#user: admin#user: $7#g" /installer/grafana/datasources/telegraf.yml
sed -i "s#RABBIT_PASSWORD: password#RABBIT_PASSWORD: ${11}#g" /installer/vars/default.yml

terraform init /installer/azure_install
terraform apply -auto-approve /installer/azure_install
sleep 75

carrierhost=`grep -w "public_ip_address" "terraform.tfstate" | cut -d: -f2 | sed s/' '//g | sed s/'"'//g | sed s/','//g`
sed -i "s/localhost/${carrierhost}/g" /installer/vars/default.yml

cat << EOF > /installer/azure_install/azhost
[myhost]
${carrierhost} ansible_user=Carrier ansible_ssh_private_key_file=/installer/azure_install/id_rsa ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
EOF

if [[ $8 == "https"  ]]; then
  sed -i "s#localhost#$9#g" /installer/vars/default.yml
  sed -i "s#admin@example.com#${10}#g" /installer/vars/default.yml
  ansible-playbook /installer/carrierbook.yml -i /installer/azure_install/azhost | tee -a /installer/static/status
else
  sed -i "s/localhost/${carrierhost}/g" /installer/vars/default.yml
  ansible-playbook /installer/carrierbookssl.yml -i /installer/azure_install/azhost | tee -a /installer/static/status
fi

echo "________________________________________________________________________________________" >> /installer/static/status ; echo " Installation is Complete " >> /installer/static/status
