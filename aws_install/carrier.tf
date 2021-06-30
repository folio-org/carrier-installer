provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_ebs_volume" "carrier_ebs" {
  availability_zone = "${var.region}a"
  size              = "${var.disk_size}"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.carrier_ebs.id
  instance_id = aws_instance.carrier.id
  skip_destroy = true
}

resource "aws_security_group" "Carrier_security_group" {
  name         = "Carrier security group"
  description  = "Carrier security group"

  ingress {
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = "${var.traefik_port}"
    to_port     = "${var.traefik_port}"
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = 4444
    to_port     = 4444
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "carrier" {
  ami            = "${var.ami}"
  availability_zone = "${var.region}a"
  instance_type  = "${var.vm_type}"
  key_name       = "${var.key_name}"
  vpc_security_group_ids = [aws_security_group.Carrier_security_group.id]
}
