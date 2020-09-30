#!/bin/bash

sed -i "s/vmtype/$1/g" /installer/gcp_install/carrier.tf
sed -i "s#ostype#$2#g" /installer/gcp_install/carrier.tf
sed -i "s/youraccname/$3/g" /installer/gcp_install/terraform.tfvars
projname=`grep -w "project_id" "/installer/gcp_install/credentials.json" | cut -d: -f2 | sed s/' '//g | sed s/'"'//g | sed s/','//g`
sed -i "s/yourprojname/${projname}/g" /installer/gcp_install/terraform.tfvars

if [[ $4 == "us-central1" ]]; then
  sed -i "s#yourregion#us-central1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "us-east1" ]]; then
  sed -i "s#yourregion#us-east1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "us-east4" ]]; then
  sed -i "s#yourregion#us-east4-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "us-west1" ]]; then
  sed -i "s#yourregion#us-west1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "us-west2" ]]; then
  sed -i "s#yourregion#us-west2-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "us-west3" ]]; then
  sed -i "s#yourregion#us-west3-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "us-west4" ]]; then
  sed -i "s#yourregion#us-west4-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "southamerica-east1" ]]; then
  sed -i "s#yourregion#southamerica-east1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "northamerica-northeast1" ]]; then
  sed -i "s#yourregion#northamerica-northeast1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "europe-north1" ]]; then
  sed -i "s#yourregion#europe-north1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "europe-west1" ]]; then
  sed -i "s#yourregion#europe-west1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "europe-west2" ]]; then
  sed -i "s#yourregion#europe-west2-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "europe-west3" ]]; then
  sed -i "s#yourregion#europe-west3-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "europe-west4" ]]; then
  sed -i "s#yourregion#europe-west4-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "europe-west6" ]]; then
  sed -i "s#yourregion#europe-west6-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "australia-southeast1" ]]; then
  sed -i "s#yourregion#australia-southeast1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-southeast1" ]]; then
  sed -i "s#yourregion#asia-southeast1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-southeast2" ]]; then
  sed -i "s#yourregion#asia-southeast2-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-south1" ]]; then
  sed -i "s#yourregion#asia-south1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-northeast1" ]]; then
  sed -i "s#yourregion#asia-northeast1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-northeast2" ]]; then
  sed -i "s#yourregion#asia-northeast2-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-northeast3" ]]; then
  sed -i "s#yourregion#asia-northeast3-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-east1" ]]; then
  sed -i "s#yourregion#asia-east1-a#g" /installer/gcp_install/terraform.tfvars
fi
if [[ $4 == "asia-east2" ]]; then
  sed -i "s#yourregion#asia-east2-a#g" /installer/gcp_install/terraform.tfvars
fi

sed -i "s#/opt#$5#g" /installer/vars/default.yml
sed -i "s#password#$6#g" /installer/vars/default.yml

cat /installer/gcp_install/terraform.tfvars
ssh-keygen -t rsa -N "" -f /installer/gcp_install/id_rsa >/dev/null

terraform init /installer/gcp_install
terraform plan -var-file=/installer/gcp_install/terraform.tfvars /installer/gcp_install
terraform apply -auto-approve -var-file=/installer/gcp_install/terraform.tfvars /installer/gcp_install | tee /installer/static/status
sleep 75

carrierhost=`grep -w "nat_ip" "terraform.tfstate" | cut -d: -f2 | sed s/' '//g | sed s/'"'//g | sed s/','//g`
accountname=`grep -w "account_name" "/installer/gcp_install/terraform.tfvars" | cut -d= -f2 | sed s/'"'//g | sed s/' '//g`
sed -i "s/localhost/${carrierhost}/g" /installer/vars/default.yml

cat << EOF > /installer/gcp_install/gcphost
[myhost]
${carrierhost} ansible_user=${accountname} ansible_ssh_private_key_file=/installer/gcp_install/id_rsa ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
EOF

ansible-playbook /installer/carrierbook.yml -i /installer/gcp_install/gcphost | tee -a /installer/static/status

echo "________________________________________________________________________________________" >> /installer/static/status ; echo " Installation is Complete " >> /installer/static/status
