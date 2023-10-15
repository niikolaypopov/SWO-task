#Creating new VPC
resource "aws_vpc" "my-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "my-vpc"
  }
}

#Creating public subnet - subnet 1
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.0.0/27"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
}

#Creating public subnet - subnet 2
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.0.32/27"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"
}

#Creating private subnet - subnet 3
resource "aws_subnet" "subnet3" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/27"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1c"
}

#Creating DB subnet for RDS instance 
resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet"
  subnet_ids = ["${aws_subnet.subnet3.id}", "${aws_subnet.subnet2.id}"]
}