# lab-terraform-modules

## What it is

A collection of reusable Terraform modules designed for lab and sandbox environments. Each module encapsulates specific infrastructure patterns to accelerate experimentation and learning.

## Why it exists

To avoid reinventing the wheel for common infrastructure components and to promote consistency across projects. These modules serve as building blocks for educational and proof-of-concept deployments.

## Quickstart

1. Navigate to the `modules/` directory and choose a module (e.g. `networking` or `compute`).
2. Copy the module to your Terraform project or use it via the module source path.
3. Run `terraform init` and `terraform apply` to deploy the module.

## Usage examples

```terraform
module "vpc" {
  source = "./modules/vpc"

  cidr_block    = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

## Roadmap

- Expand module library to cover databases, IAM roles, and monitoring.
- Add examples and documentation for each module.
- Integrate module testing and static analysis into CI.

## Security notes

These modules are intended for non-production, educational use. For production workloads, review and harden configurations accordingly.
