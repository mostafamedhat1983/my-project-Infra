# Packer configuration for building Jenkins master AMI
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

# Source configuration: Amazon Linux 2023 base image
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

# Build configuration
build {
  name    = "jenkins-build"
  sources = ["source.amazon-ebs.aws"]
  
  # Install Jenkins, Docker, kubectl, and other tools via Ansible
  provisioner "ansible" {
    playbook_file = "./ansible/jenkins-playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }
  
  # Run Trivy security scan for vulnerabilities (fails build if HIGH/CRITICAL found)
  provisioner "shell" {
    inline = [
      "sudo dnf install -y wget",
      "wget -qO - https://aquasecurity.github.io/trivy-repo/rpm/public.key | sudo rpm --import -",
      "sudo dnf install -y trivy",
      "sudo trivy rootfs / --severity HIGH,CRITICAL --exit-code 1 --format json --output /tmp/trivy-report.json",
      "sudo trivy rootfs / --severity HIGH,CRITICAL --exit-code 1 --format table"
    ]
  }
  
  # Download security scan results with timestamp
  provisioner "file" {
    source      = "/tmp/trivy-report.json"
    destination = "trivy-report-${formatdate("YYYY-MM-DD-hhmm", timestamp())}.json"
    direction   = "download"
  }
  
  # Save AMI ID and build metadata
  post-processor "manifest" {
    output = "manifest.json"
  }
}
