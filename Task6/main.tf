
# below block you might want to move to a file called versions.tf
terraform {
  required_version = ">1.0"
  required_providers {
    aws = {
      version = "~>3.6"
    }
  }
}


# you might want to move the block below to a file called aws_provider.tf
provider "aws" {
  region     = var.region
  access_key = var.awsstuff.aws_access_key_id
  secret_key = var.awsstuff.aws_secret_key
}


#Hardcoding the instances for the moment, you can use filters in the VPC and populate these instance IDs 



data "aws_instance" "ec2-1" {
 instance_id = "i-0XXXXXXXXXXXXXXX" # insert instance ID for front end 
}


data "aws_instance" "ec2-2" {
 instance_id = "i-0XXXXXXXXXXXXXXX" # insert instance ID for back end 
}


data "aws_instance" "ec2-3" {
 instance_id = "i-0XXXXXXXXXXXXXXX" # insert instance ID for DB
}




#track the state of the ec2(optional)
locals {
 ec2state= data.aws_instance.ec2-1.instance_state
}




#for DB EC2
# modify docker containers on the ec2  
resource "null_resource" "ec2-3e" {
  triggers = {
    build_number = timestamp()
  }
  provisioner "remote-exec" {
    inline = [
      #here we can docker compose whatever we are interested in 
      
      #here we can docker compose whatever we are interested in 

      
      
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo chmod 666 /var/run/docker.sock",  
      
      # Code for Compose- CLContainers
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "docker-compose --version",
      "sudo yum install git -y",
      "git clone https://github.com/achintya96/cisco-live-2022-aws-containers",
      "cd cisco-live-2022-aws-containers/ciscolive-containers",
      "cp docker-compose-db.yaml docker-compose.yaml",
      "docker-compose up -d"
      
      
     
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # this is the inbuilt ec2 user name for the used ami
      private_key = file("${path.module}/keypair/privatekeyterraform")
      host        = data.aws_instance.ec2-3.public_ip
    }
  }
}




#for Backend EC2
# modify docker containers on the ec2  
resource "null_resource" "ec2-2e" {
  triggers = {
    build_number = timestamp()
  }
  provisioner "remote-exec" {
    inline = [
      #here we can docker compose whatever we are interested in 

      
      
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo chmod 666 /var/run/docker.sock",  
      
      # Code for Compose- SinglePage
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "docker-compose --version",
      "sudo yum install git -y",
      "git clone https://github.com/achintya96/cisco-live-2022-aws-containers",
      "cd cisco-live-2022-aws-containers/ciscolive-containers",
      "cp docker-compose-be.yaml docker-compose.yaml",
      "docker-compose up -d"
          
 
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # this is the inbuilt ec2 user name for the used ami
      private_key = file("${path.module}/keypair/privatekeyterraform")
      host        = data.aws_instance.ec2-2.public_ip
    }
  }
}


# modify docker containers on the ec2  
resource "null_resource" "ec2-1e" {
  triggers = {
    build_number = timestamp()
  }
  provisioner "remote-exec" {
    inline = [
      #first docker-compose down then we compose the application web page image.    
      "docker ps",
      #here we can docker compose whatever we are interested in 
      #"git clone https://github.com/achintya96/cisco-live-2022-aws-containers",
      "cd cisco-live-2022-aws-containers/singlepage",
      "docker-compose down",
      
      "cd ~/cisco-live-2022-aws-containers/ciscolive-containers",
      "cp docker-compose-fe.yaml docker-compose.yaml",
      "docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # this is the inbuilt ec2 user name for the used ami
      private_key = file("${path.module}/keypair/privatekeyterraform")
      host        = data.aws_instance.ec2-1.public_ip
    }
  }
}




data "aws_security_groups" "sg2" {

tags= {
 AciDnTag= "*EPG_Backend*"
}
}



data "aws_security_groups" "sg3" {

tags= {
 AciDnTag= "*EPG_DB*"
}
}


locals{

securitygroup2=element(tolist(data.aws_security_groups.sg2.ids),0)
securitygroup3=element(tolist(data.aws_security_groups.sg3.ids),0)
}


resource "aws_security_group_rule" "secgroup2-internet" {

 type = "egress" 
 from_port = 443
 to_port = 443
 protocol = "tcp"
 security_group_id = local.securitygroup2
 cidr_blocks=["0.0.0.0/0"]

}

resource "aws_security_group_rule" "secgroup2-internet-80expose" {

 type = "ingress" 
 from_port = 80
 to_port = 80
 protocol = "tcp"
 security_group_id = local.securitygroup2
 cidr_blocks=["0.0.0.0/0"]

}


resource "aws_security_group_rule" "secgroup3-internet" {

 type = "egress" 
 from_port = 443
 to_port = 443
 protocol = "tcp"
 security_group_id = local.securitygroup3
 cidr_blocks=["0.0.0.0/0"]

}

resource "aws_security_group_rule" "secgroup3-internet-80expose" {

 type = "ingress" 
 from_port = 80
 to_port = 80
 protocol = "tcp"
 security_group_id = local.securitygroup3
 cidr_blocks=["0.0.0.0/0"]

}










# Outputs:   (could put in separate file like output.tf also)



output "ec2-1-publicip" {
  value = data.aws_instance.ec2-1.public_ip
}


