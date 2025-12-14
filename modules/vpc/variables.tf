variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Optional list of availability zones to pin subnets to. When provided, the list length must match the number of subnets in each tier."
  default     = []

  validation {
    condition = length(var.availability_zones) == 0 || (
      length(var.availability_zones) == length(var.public_subnets) &&
      length(var.public_subnets) == length(var.private_subnets)
    )
    error_message = "If availability_zones is set, it must include an entry for each public and private subnet."
  }
}

variable "enable_internet_gateway" {
  type        = bool
  description = "Create and attach an internet gateway to the VPC for outbound internet access."
  default     = true
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateways for private subnet egress."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Create a single shared NAT gateway instead of one per availability zone. Only used when enable_nat_gateway is true."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to resources"
  default     = {}
}

variable "subnet_tags" {
  type        = map(string)
  description = "Additional tags applied to all subnets"
  default     = {}
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Additional tags applied only to public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Additional tags applied only to private subnets"
  default     = {}
}

variable "route_table_tags" {
  type        = map(string)
  description = "Additional tags applied to all route tables created by this module"
  default     = {}
}

variable "enable_flow_logs" {
  type        = bool
  description = "Create a CloudWatch Logs flow log for the VPC to capture network traffic metadata."
  default     = false
}

variable "flow_logs_retention_days" {
  type        = number
  description = "Retention period (in days) for the flow log CloudWatch log group when flow logs are enabled."
  default     = 14
}

variable "flow_logs_traffic_type" {
  type        = string
  description = "Traffic type to capture in flow logs. Valid options: ALL, ACCEPT, REJECT."
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "ACCEPT", "REJECT"], var.flow_logs_traffic_type)
    error_message = "flow_logs_traffic_type must be one of: ALL, ACCEPT, REJECT."
  }
}
