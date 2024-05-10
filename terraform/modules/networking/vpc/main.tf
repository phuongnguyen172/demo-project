data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name        = var.vpc_name
    Environment = var.env
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_cidr_block)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.private_subnet_name}-${count.index + 1}"
    Environment = var.env
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_cidr_block)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_block[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.public_subnet_name}-${count.index + 1}"
    Environment = var.env
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name        = "PrivateRouteTable"
    Environment = var.env
  }

  depends_on = [aws_nat_gateway.natgw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "PublicRouteTable"
    Environment = var.env
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = var.internet_gateway_name
    Environment = var.env
  }
}

resource "aws_eip" "natgw_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id     = aws_eip.natgw_eip.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnets[0].id

  tags = {
    Name        = var.nat_gateway_name
    Environment = var.env
  }
}
