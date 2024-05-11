# creating vpc and its dependencies 
resource "aws_vpc" "testvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "testvpc"
  }
}

resource "aws_subnet" "publicsubnet" { 
  vpc_id            = aws_vpc.testvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "testvpc-internetgateway" {
  vpc_id = aws_vpc.testvpc.id
  tags = {
    "name" = "testvpc-internetgateway"
  }
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.testvpc.id
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.testvpc-internetgateway.id
}

resource "aws_route_table_association" "aws_route_table_association" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.routetable.id
}
# new resourse for security group creation 
resource "aws_security_group" "testvpc_securitygroup" {
  name        = "testvpc_securitygroup"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.testvpc.id

  tags = {
    Name = "testvpc_securitygroup"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.testvpc_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.testvpc_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.testvpc_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
