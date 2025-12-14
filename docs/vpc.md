# VPC module architecture

This document describes the design decisions behind the VPC module so you can quickly assess suitability for your lab use cases.

## Goals

- Provide a sensible, low-friction VPC baseline for iterative experiments.
- Mirror production patterns where practical (separate tiers, NAT egress, centralized tagging), while keeping cost controls in mind.
- Keep configuration surface area compact yet explicit.

## Topology overview

- One VPC with DNS hostnames and DNS support enabled by default.
- Public subnets expose resources through an internet gateway and a shared public route table.
- Private subnets rely on a NAT gateway for egress when enabled; the module supports a single cost-optimized NAT or per-AZ deployment for higher resilience.
- Optional VPC flow logs route to CloudWatch Logs with configurable retention.

## Tagging strategy

The module predefines base tags `Name` and `Environment` and merges user-supplied tags on top. Subnets also receive a `Tier` tag (`public` or `private`) to make it easy to target them in security tooling or cost analysis.

## Cost considerations

- NAT gateways carry hourly and data processing charges—favor `single_nat_gateway = true` for most labs.
- Flow logs can grow quickly in busy environments; adjust `flow_logs_retention_days` to balance observability and storage spend.
- All resources are created in the account and region of the configured AWS provider. Destroy resources promptly after experiments to avoid drift and unnecessary charges.

## Validation approach

Use the `examples/vpc-basic` configuration as a smoke test. From that directory run:

```bash
terraform init
terraform validate
```

When Terraform is available, CI should also run `terraform fmt -recursive` from the repository root to enforce consistent formatting.
