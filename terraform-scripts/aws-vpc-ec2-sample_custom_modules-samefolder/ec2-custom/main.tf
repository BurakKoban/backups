resource "aws_instance" "sample_instance" {
    ami = data.aws_ami.amzn-linux-2023-ami.id
    instance_type = var.ec2_instance_type
    key_name = aws_key_pair.sample_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.sg_8080.id]
    #subnet_id     = "subnet-07c365aed09a69010"
    subnet_id     = data.terraform_remote_state.vpc_module.outputs.subnet_id
    

    user_data              = <<-EOF
              #!/bin/bash
              yum update
              yum install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World from Burak" > /var/www/html/index.html
              systemctl restart apache2
              EOF
    

    tags = {
     Name = "sample_ec2"
   }
}

resource "aws_security_group" "sg_8080" {
  name = "sample-ec2-sg"
  vpc_id = data.terraform_remote_state.vpc_module.outputs.vpc_id
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Creates a pem file

resource "tls_private_key" "rsa_4096" {
  algorithm     = "RSA"
  rsa_bits      = 4096
}


resource "aws_key_pair" "sample_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}