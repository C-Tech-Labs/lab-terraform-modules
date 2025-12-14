# VPC basic example

This example composes the `modules/vpc` module to provision a two-AZ VPC with public and private subnets, a single NAT gateway, and VPC flow logs enabled. Use it to validate the module or as a starting point for more complex topologies.

## How to use

1. Set AWS credentials in your environment (e.g., `AWS_PROFILE`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
2. Initialize the working directory:

   ```bash
   terraform init
   ```

3. Review and adjust default variables in `variables.tf` if needed.
4. Validate and apply:

   ```bash
   terraform validate
   terraform apply
   ```

5. Destroy when finished to avoid ongoing NAT gateway charges:

   ```bash
   terraform destroy
   ```

The example outputs the VPC ID and the subnet IDs for quick inspection or downstream use.
