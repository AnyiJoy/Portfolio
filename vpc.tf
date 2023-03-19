#create an aws vpc
resource "aws_vpc" "Joy-vpc" {
    cidr_block  = "10.0.0.0/16"
    enable_dns_hostnames = true 
    enable_dns_support = true
    tags = { Name = "Joy-vpc"}
}

#creates an internet gateway
resource "aws_internet_gateway" "Joy_internet_gateway" {
    vpc_id = aws_vpc.Joy-vpc.id
    tags = {
        Name = "Joy_internet_gateway"
    }
}


#creates a public route table
resource "aws_route_table" "Joy-route-table-public" {
    vpc_id = aws_vpc.Joy-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Joy_internet_gateway.id
    }
    tags = {
        Name = "Altschool-route-table-public"
    }
}


#Associate public subnet 1 with public route table
resource "aws_route_table_association" "Joy-public-subnet1-association" {
  subnet_id      = aws_subnet.Joy-public-subnet1.id
  route_table_id = aws_route_table.Joy-route-table-public.id
}


# Associate public subnet 2 with public route table
resource "aws_route_table_association" "Altschool-public-subnet2-association" {
  subnet_id      = aws_subnet.Joy-public-subnet2.id
  route_table_id = aws_route_table.Joy-route-table-public.id
}

#create public subnet-1
resource "aws_subnet" "Joy-public-subnet1" {
  vpc_id                  = aws_vpc.Joy-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "Joy-public-subnet1"
  }
}


# Create Public Subnet-2
resource "aws_subnet" "Joy-public-subnet2" {
  vpc_id                  = aws_vpc.Joy-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"
  tags = {
    Name = "Altschool-public-subnet2"
  }
}

/* Network ACI */
resource "aws_network_acl" "Joy-network_acl" {
  vpc_id     = aws_vpc.Joy-vpc.id
  subnet_ids = [aws_subnet.Joy-public-subnet1.id, aws_subnet.Joy-public-subnet2.id]

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

