# RDS Module

Creates RDS MySQL instance with Secrets Manager integration for credential management.

## Usage

```hcl
module "rds" {
  source = "../modules/rds"

  identifier           = "todo-db-dev"
  db_subnet_group_name = "todo-db-subnet-group-dev"
  secret_name          = "todo-db-dev-credentials"
  
  subnet_ids = [
    module.network.private_subnet_ids["rds-2a"],
    module.network.private_subnet_ids["rds-2b"]
  ]
  
  vpc_security_group_ids = [module.network.rds_sg_id]
  
  storage_size   = 20
  storage_type   = "gp3"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  multi_az                = false
  backup_retention_period = 1
  skip_final_snapshot     = true
  
  tags = {
    Name = "todo-db-dev"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| identifier | The DB instance identifier | `string` | n/a | yes |
| db_subnet_group_name | Name for the DB subnet group | `string` | n/a | yes |
| secret_name | Name of the Secrets Manager secret containing RDS credentials | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for the DB subnet group | `list(string)` | n/a | yes |
| vpc_security_group_ids | List of VPC security groups to associate | `list(string)` | `[]` | no |
| storage_size | The size of the database storage in gigabytes | `number` | n/a | yes |
| storage_type | The storage type to be associated with the DB instance | `string` | `"gp3"` | no |
| engine | The engine type of the database | `string` | n/a | yes |
| engine_version | The version of the database engine | `string` | n/a | yes |
| instance_class | The instance class of the database | `string` | n/a | yes |
| multi_az | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| backup_retention_period | The days to retain backups for the DB instance | `number` | n/a | yes |
| skip_final_snapshot | Determines whether a final DB snapshot is created before deletion | `bool` | `true` | no |
| final_snapshot_identifier | The name of the final DB snapshot when skip_final_snapshot is false | `string` | `null` | no |
| parameter_group_name | The name of the DB parameter group to associate | `string` | `null` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_endpoint | RDS instance endpoint (host:port) |
| db_address | RDS instance hostname |
| db_port | RDS instance port |
| db_name | Database name |
| db_instance_id | RDS instance ID |

## Features

- Reads credentials from AWS Secrets Manager
- Automatically updates Secrets Manager with RDS endpoint after creation
- Encrypted storage at rest
- Configurable Multi-AZ for high availability
- Automated backups with configurable retention
- Optional final snapshot on deletion
