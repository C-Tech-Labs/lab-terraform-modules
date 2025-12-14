# VPC Module

A production-grade but lab-friendly AWS VPC module that builds public and private subnets, routing, optional NAT gateways, and VPC flow logs with sensible tagging defaults.

## Features

- Opinionated defaults for lab environments (DNS enabled, clear naming conventions, environment tag).
- Public and private subnets with optional AZ pinning.
- Internet gateway and NAT gateways (single or per-AZ) with route tables wired for outbound access.
- Optional VPC flow logs with configurable retention.
- Tag propagation helpers for consistent metadata across resources.

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `vpc_cidr` | CIDR block for the VPC | `string` | `"10.0.0.0/16"` |
| `public_subnets` | List of CIDR blocks for public subnets | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `private_subnets` | List of CIDR blocks for private subnets | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24"]` |
| `availability_zones` | Optional AZs matching the subnet lists | `list(string)` | `[]` |
| `enable_internet_gateway` | Attach an internet gateway to the VPC | `bool` | `true` |
| `enable_nat_gateway` | Create NAT gateways for private subnet egress | `bool` | `true` |
| `single_nat_gateway` | Use a single NAT instead of one per AZ | `bool` | `true` |
| `tags` | Base tags applied to all resources | `map(string)` | `{}` |
| `subnet_tags` | Extra tags for all subnets | `map(string)` | `{}` |
| `public_subnet_tags` | Extra tags for public subnets only | `map(string)` | `{}` |
| `private_subnet_tags` | Extra tags for private subnets only | `map(string)` | `{}` |
| `route_table_tags` | Extra tags for route tables | `map(string)` | `{}` |
| `enable_flow_logs` | Enable VPC flow logs to CloudWatch | `bool` | `false` |
| `flow_logs_retention_days` | Retention period for flow logs | `number` | `14` |
| `flow_logs_traffic_type` | Flow log traffic type (`ALL`, `ACCEPT`, `REJECT`) | `string` | `"ALL"` |

## Outputs

| Name | Description |
| --- | --- |
| `vpc_id` | ID of the created VPC |
| `public_subnet_ids` | IDs of the public subnets |
| `private_subnet_ids` | IDs of the private subnets |
| `internet_gateway_id` | ID of the internet gateway when created |
| `nat_gateway_ids` | IDs of NAT gateways when created |
| `public_route_table_id` | ID of the public route table |
| `private_route_table_id` | ID of the private route table |
| `flow_log_id` | ID of the flow log configuration when enabled |

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = "10.20.0.0/16"
  public_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnets = ["10.20.101.0/24", "10.20.102.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]

  enable_flow_logs = true
  single_nat_gateway = false

  tags = {
    Environment = "dev"
    Owner       = "your-name"
  }
}
```

## Notes and tips

- When `enable_nat_gateway` is `false`, private subnets will not receive default internet egress routes.
- NAT gateways incur hourly and data processing charges. Use `single_nat_gateway = true` for lab scenarios that do not require AZ fault tolerance.
- Flow logs require IAM permissions for CloudWatch Logs and may generate significant volumes depending on traffic; adjust `flow_logs_retention_days` accordingly.
- Keep the `availability_zones` list aligned with your subnet lists to avoid misalignment and ensure deterministic placements.
