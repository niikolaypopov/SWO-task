#Creating Internet Gateway
resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.my-vpc.id
}

#Route table for public subnet and association for subnet 1
resource "aws_route_table" "pubsub_gw" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }
}

resource "aws_route_table_association" "pubsub_assc" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.pubsub_gw.id
}

#Route table for public subnet and association for subnet 2
resource "aws_route_table_association" "pubsub_assc2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.pubsub_gw.id
}

#Elastic IP for NAT
resource "aws_eip" "eip_nat" {
  depends_on = [aws_internet_gateway.my-gw]
  tags = {
    Name = "Elastic IP for NAT"
  }
}

resource "aws_nat_gateway" "prvsub_nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.subnet3.id

  tags = {
    Name = "NAT for private subnet"
  }

  depends_on = [aws_internet_gateway.my-gw]
}

#Route table for private subnet and association for subnet 3
resource "aws_route_table" "prisub_nat" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prvsub_nat.id
  }
}

resource "aws_route_table_association" "prvsub_assc" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.prisub_nat.id
}