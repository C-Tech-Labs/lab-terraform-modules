# VPC Module

This module creates a basic AWS VPC with public and private subnets. It also tags resources and outputs IDs for use by other modules.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| vpc_cidr | CIDR block for the VPC | string | `"10.0.0.0/16"` |
| public_subnets | List of CIDR blocks for public subnets | list(string) | `["10.0.1.0/24","10.0.2.0/24"]` |
| private_subnets | List of CIDR blocks for private subnets | list(string) | `["10.0.101.0/24","10.0.102.0/24"]` |
| tags | Map of tags to apply to resources | map(string) | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the created VPC |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |

## Usage

```
hcl
module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = "10.20.0.0/16"
  public_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnets = ["10.20.101.0/24", "10.20.102.0/24"]

  tags = {
    Environment = "dev"
    Owner       = "your-name"
  }
}
```
