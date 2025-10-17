# EC2 Module

Creates EC2 instances with encrypted EBS volumes and optional IAM instance profile.

## Usage

```hcl
module "ec2" {
  source = "../modules/ec2"
  
  ami                    = "ami-0ea3c35c5c3284d82"
  instance_type          = "t2.medium"
  availability_zone      = "us-east-2a"
  subnet_id              = module.network.private_subnet_ids["jenkins-2a"]
  vpc_security_group_ids = [module.network.jenkins_sg_id]
  iam_instance_profile   = module.jenkins_role.instance_profile_name
  
  tags = {
    Name = "jenkins-dev-2a"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami | The AMI ID to use for the EC2 instance | `string` | n/a | yes |
| instance_type | The type of EC2 instance | `string` | n/a | yes |
| availability_zone | The availability zone for the EC2 instance | `string` | n/a | yes |
| subnet_id | The Subnet ID for the EC2 instance | `string` | n/a | yes |
| vpc_security_group_ids | List of security group IDs | `list(string)` | n/a | yes |
| iam_instance_profile | The IAM instance profile to associate with the instance | `string` | `null` | no |
| tags | Tags to assign to the EC2 instance | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | The ID of the EC2 instance |
| private_ip | The private IP of the EC2 instance |

## Features

- Encrypted EBS root volume (20GB gp3)
- Metadata service v2 (IMDSv2) enforced
- Supports IAM instance profile for AWS service access
- Customizable tags
