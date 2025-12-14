variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner tag"
  type        = string
  default     = "example-user"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to deploy subnets to"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_flow_logs" {
  description = "Toggle VPC flow logs"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Toggle NAT gateway creation"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway instead of one per AZ"
  type        = bool
  default     = true
}

variable "enable_internet_gateway" {
  description = "Attach an internet gateway"
  type        = bool
  default     = true
}
