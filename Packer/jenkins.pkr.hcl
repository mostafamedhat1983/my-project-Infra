packer {

  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

  source "amazon-ebs" "aws" {
  ami_name      = "jenkins-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  instance_type = "t3.medium"
  region        = "us-east-2"
  
    source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  
  ssh_username = "ec2-user"
} 

  build {
    name    = "jenkins-build"
    sources = [
      "source.amazon-ebs.aws"
    ]
      provisioner "ansible" {
    playbook_file = "./ansible/jenkins-playbook.yml"
  }
  
  }

