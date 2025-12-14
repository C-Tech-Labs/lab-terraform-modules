# Scripts

This directory contains helper scripts for working with the Terraform modules. Use these scripts to automate tasks such as provisioning resources, cleaning up environments, or running module tests.

- `validate.sh` – runs `terraform fmt -check` across the repo and validates each example configuration with `terraform init -backend=false` followed by `terraform validate`.
