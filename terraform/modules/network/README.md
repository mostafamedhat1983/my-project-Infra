# Network Module

Creates VPC with public/private subnets, NAT gateways, Internet Gateway, route tables, and security groups for Jenkins, RDS, EKS, and VPC endpoints.

## Usage

```hcl
module "network" {
  source = "../modules/network"

  vpc_name       = "vpc-dev"
  vpc_cidr_block = "10.0.0.0/16"
  
  public_subnets = {
    public-2a = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-2a"
      name              = "public-subnet-2a"
    }
  }
  
  private_subnets = {
    jenkins-2a = {
      cidr_block        = "10.0.10.0/24"
      availability_zone = "us-east-2a"
      name              = "jenkins-subnet-2a"
    }
  }
  
  igw_name          = "igw-dev"
  nat_gateway_count = 1
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | Name of the VPC | `string` | n/a | yes |
| vpc_cidr_block | CIDR block for the VPC | `string` | n/a | yes |
| public_subnets | Map of public subnet configurations | `map(object({ cidr_block = string, availability_zone = string, name = string }))` | n/a | yes |
| private_subnets | Map of private subnet configurations | `map(object({ cidr_block = string, availability_zone = string, name = string }))` | n/a | yes |
| igw_name | Name of the Internet Gateway | `string` | n/a | yes |
| nat_gateway_count | Number of NAT gateways to create (1 for dev, 2 for prod) | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| public_subnet_ids | Map of public subnet IDs |
| private_subnet_ids | Map of private subnet IDs |
| internet_gateway_id | The ID of the Internet Gateway |
| nat_gateway_ids | Map of NAT Gateway IDs |
| route_table_ids | Map of route table IDs (public and private) |
| jenkins_sg_id | Jenkins security group ID |
| rds_sg_id | RDS security group ID |
| eks_node_sg_id | EKS node security group ID |
| vpc_endpoints_sg_id | VPC endpoints security group ID |
| eip_ids | Map of Elastic IP IDs for NAT gateways |

## Resources Created

- VPC
- Public subnets (2)
- Private subnets (6: Jenkins, EKS, RDS per AZ)
- Internet Gateway
- NAT Gateway(s) with Elastic IPs
- Route tables and associations
- Security groups (Jenkins, RDS, EKS nodes, VPC endpoints)
