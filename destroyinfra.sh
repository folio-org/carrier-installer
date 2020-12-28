export GOOGLE_APPLICATION_CREDENTIALS=/installer/gcp_install/credentials.json
export AWS_DEFAULT_REGION=`grep -w "region" "/installer/aws_install/terraform.tfvars" | cut -d: -f2 | sed s/' '//g | sed s/'"'//g | sed s/','//g | sed s/'region='//g`
export AWS_ACCESS_KEY_ID=`grep -w "access_key" "/installer/aws_install/terraform.tfvars" | cut -d: -f2 | sed s/' '//g | sed s/'"'//g | sed s/','//g | sed s/'access_key='//g`
export AWS_SECRET_ACCESS_KEY=`grep -w "secret_key" "/installer/aws_install/terraform.tfvars" | cut -d: -f2 | sed s/' '//g | sed s/'"'//g | sed s/','//g | sed s/'secret_key='//g`
terraform destroy -auto-approve -no-color > /installer/static/status
