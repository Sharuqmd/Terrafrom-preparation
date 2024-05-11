# creating vpc and its dependencies
resource "aws_vpc" "testvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "publicsubnet" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
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
resource "aws_security_group" "testvpc_aws_security_group" {
  name        = "testvpc_aws_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.testvpc.id
  tags = {
    Name = "testvpc_aws_security_group"
  }

 ingress {
 description = "tls from vpc"
 from_port = 22
 to_port = 22
 cidr_blocks = ["0.0.0.0/0"]
 protocol = "tcp"
 }
 ingress {
 description = "tls from vpc http"
 from_port = 80
 to_port = 80
 cidr_blocks = ["0.0.0.0/0"]
 protocol = "tcp"
 }

 egress {
 description = "tls from vpc allow all outbound"
 from_port = 0
 to_port = 0
 cidr_blocks = ["0.0.0.0/0"]
 protocol = "-1"
 }
}
