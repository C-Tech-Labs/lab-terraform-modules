# lab-terraform-modules

A collection of reusable Terraform modules designed for lab and sandbox environments. Each module encapsulates specific infrastructure patterns—such as VPC networking, routing, and observability hooks—to accelerate experimentation and learning while mirroring production-grade topologies.

## What it is

- Opinionated infrastructure building blocks with safe defaults for non-production use (e.g., NAT gateway toggles, optional flow logs, and tagging conventions).
- Self-contained modules with variables, outputs, and example compositions so you can lift-and-shift into your own Terraform root modules.
- Documentation and helper scripts to make validation and iteration straightforward, including a repository-wide validation script.

## Why it exists

To avoid reinventing the wheel for common infrastructure components and to promote consistency across projects. These modules serve as building blocks for educational and proof-of-concept deployments while still mirroring production-grade patterns.

## Quickstart

1. Navigate to the `modules/` directory and choose a module (e.g., `vpc`). Each module README lists inputs, outputs, and architecture notes.
2. Copy the module to your Terraform project or reference it directly via the local path.
3. Review and set required variables (CIDR ranges, subnet counts, tagging map). Examples under `examples/` show minimal and advanced configurations.
4. Initialize and validate: `terraform init` then `terraform validate` from the root where you consume the module.
5. Apply to your target account: `terraform apply`. For AWS, ensure your credentials/profile are configured before applying.

## Usage example

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  azs = ["us-east-1a", "us-east-1b"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_flow_logs   = true

  tags = {
    Environment = "dev"
    Owner       = "demo-user"
  }
}
```

## Repository layout

- `modules/` – Reusable modules (see each module README for variables and outputs).
- `examples/` – Ready-to-run configurations demonstrating module composition; start with `examples/vpc-basic` to provision a VPC with public/private subnets, NAT, and flow logs.
- `docs/` – Extended documentation and design notes.
- `scripts/` – Helper scripts for formatting and validation. Use `scripts/validate.sh` to run formatting and Terraform validation across all modules and examples.

## Testing and validation

- Format Terraform files: `terraform fmt -recursive`.
- Validate module syntax: `terraform validate` in each example folder or module consumer project (e.g., `cd examples/vpc-basic && terraform validate`).
- For CI or local sweeps, run `./scripts/validate.sh` to perform formatting and validation across the repository.

## Security notes

These modules are intended for non-production, educational use. For production workloads, review and harden configurations accordingly, and enable appropriate guardrails such as AWS Config rules, stricter IAM boundaries, and centralized logging.
