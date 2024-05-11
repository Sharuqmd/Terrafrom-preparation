resource "aws_vpc" "testvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "testvpc"
  }
}

resource "aws_subnet" "testvpc.publicsubnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.testvpc.id
  availability_zone = "ap-south-1"
  map_public_ip_on_launch = true
}
