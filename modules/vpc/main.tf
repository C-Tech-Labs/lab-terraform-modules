terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  base_tags = merge({
    Name        = "lab-vpc"
    Environment = "lab"
  }, var.tags)

  subnet_tags = merge(var.subnet_tags, { Tier = "shared" })
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.base_tags
}

resource "aws_internet_gateway" "this" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, { Name = "lab-igw" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[count.index] : null
  map_public_ip_on_launch = true

  tags = merge(local.subnet_tags, var.public_subnet_tags, {
    Name = "lab-public-${count.index}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = length(var.availability_zones) > 0 ? var.availability_zones[count.index] : null

  tags = merge(local.subnet_tags, var.private_subnet_tags, {
    Name = "lab-private-${count.index}"
    Tier = "private"
  })
}

resource "aws_eip" "nat" {
  count      = var.enable_nat_gateway && var.enable_internet_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnets)) : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = merge(local.base_tags, { Name = "lab-nat-eip-${count.index}" })
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway && var.enable_internet_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnets)) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, var.single_nat_gateway ? 0 : count.index)

  tags = merge(local.base_tags, { Name = "lab-nat-${count.index}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, var.route_table_tags, { Name = "lab-public-rt" })
}

resource "aws_route" "public_internet" {
  count                  = var.enable_internet_gateway ? 1 : 0
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, var.route_table_tags, { Name = "lab-private-rt" })
}

resource "aws_route" "private_nat" {
  count                  = var.enable_nat_gateway && length(aws_nat_gateway.this) > 0 ? length(aws_subnet.private) : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, var.single_nat_gateway ? 0 : count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = "/aws/vpc/${aws_vpc.this.id}/flow"
  retention_in_days = var.flow_logs_retention_days

  tags = merge(local.base_tags, { Name = "lab-vpc-flow-logs" })
}

resource "aws_flow_log" "this" {
  count                = var.enable_flow_logs ? 1 : 0
  log_destination_type = "cloud-watch-logs"
  log_group_name       = aws_cloudwatch_log_group.flow_logs[0].name
  traffic_type         = var.flow_logs_traffic_type
  vpc_id               = aws_vpc.this.id
}
