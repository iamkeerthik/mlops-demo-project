############################
# VPC
############################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-mlops-vpc"
    Env  = var.env
  }
}

############################
# Internet Gateway
############################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env}-igw"
  }
}

############################
# Public Subnets
############################
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}${char(97 + each.key)}" # a, b, c ...

  tags = {
    Name = "${var.env}-public-subnet-${each.key + 1}"
    Tier = "public"
  }
}

############################
# Private Subnets
############################
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${char(97 + each.key)}"

  tags = {
    Name = "${var.env}-private-subnet-${each.key + 1}"
    Tier = "private"
  }
}

############################
# NAT Gateway (only if private subnet exists)
############################
resource "aws_eip" "nat" {
  count  = length(var.private_subnet_cidrs) > 0 ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  count         = length(var.private_subnet_cidrs) > 0 ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.env}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.this]
}

############################
# Public Route Table
############################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

############################
# Private Route Table (only if private subnet exists)
############################
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = "${var.env}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = length(var.private_subnet_cidrs) > 0 ? aws_subnet.private : {}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}