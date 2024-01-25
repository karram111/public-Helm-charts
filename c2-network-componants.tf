# Resources Block
# Resource-1: Create VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "vpc-dev"
  }
}

# Resource-2: Create public Subnets
resource "aws_subnet" "vpc-dev-public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-1"
  }
}

/*# Resource-3: Create public Subnets
resource "aws_subnet" "vpc-dev-public-subnet-2" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-2"
  }
}

# Resource-4: Create private Subnets
resource "aws_subnet" "vpc-dev-private-subnet-1" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  tags = {
    "Name" = "private-subnet-1"
  }
}

# Resource-5: Create private Subnets
resource "aws_subnet" "vpc-dev-private-subnet-2" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  tags = {
    "Name" = "private-subnet-2"
  }
}

# Resource-7: Create Private Route Table
resource "aws_route_table" "vpc-dev-private-route-table" {
  vpc_id = aws_vpc.vpc-dev.id
  tags = {
    "Name" = "Private-RT"
  }
}

# Resource-9: NAT Gateway
resource "aws_nat_gateway" "vpc-dev-nat-gateway" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]  
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  subnet_id     = aws_subnet.vpc-dev-public-subnet-1.id
  tags = {
    Name = "NAT-GW"
  }
}
*/

# Resource-6: Create Public Route Table
resource "aws_route_table" "vpc-dev-public-route-table" {
  vpc_id = aws_vpc.vpc-dev.id
  tags = {
    "Name" = "Public-RT"
  }
}

# Resource-8: Internet Gateway
resource "aws_internet_gateway" "vpc-dev-igw" {
  depends_on = [
    aws_vpc.vpc-dev,
    aws_subnet.vpc-dev-public-subnet-1
  ]
  vpc_id = aws_vpc.vpc-dev.id
}





# Resource-10: Create Route in Public Route Table for Internet Access
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = aws_route_table.vpc-dev-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-dev-igw.id
}

/*# Resource-11: Create Route in Private Route Table for Internet Access through NAT GW
resource "aws_route" "vpc-dev-private-route" {
  route_table_id         = aws_route_table.vpc-dev-private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.vpc-dev-nat-gateway.id
}*/

# Resource-6: Associate the public Route Table with the public Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate01" {
  route_table_id = aws_route_table.vpc-dev-public-route-table.id
  subnet_id      = aws_subnet.vpc-dev-public-subnet-1.id
}

/*# Resource-6: Associate the private Route Table with the private Subnet
resource "aws_route_table_association" "vpc-dev-private-route-table-associate02" {
  route_table_id = aws_route_table.vpc-dev-private-route-table.id
  subnet_id = aws_subnet.vpc-dev-private-subnet-1.id
}

# Resource-6: Associate the public Route Table with the public Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate03" {
  route_table_id = aws_route_table.vpc-dev-public-route-table.id
  subnet_id      = aws_subnet.vpc-dev-public-subnet-2.id
}

# Resource-6: Associate the private Route Table with the private Subnet
resource "aws_route_table_association" "vpc-dev-private-route-table-associate04" {
  route_table_id = aws_route_table.vpc-dev-private-route-table.id
  subnet_id = aws_subnet.vpc-dev-private-subnet-2.id
}

# Resource-7: Create Security Group
resource "aws_security_group" "dev-vpc-private-sg" {
  name        = "private_sg"
  description = "Dev VPC Default Security Group"
  vpc_id      = aws_vpc.vpc-dev.id
  tags = {
    Name = "private_sg"
  }

  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}*/

# Resource-7: Create Security Group
resource "aws_security_group" "dev-vpc-public-sg" {
  name        = "public-sg"
  description = "Dev VPC Default Security Group"
  vpc_id      = aws_vpc.vpc-dev.id
  tags = {
    Name = "public-sg"
  }

  ingress {
    description = "Allow all trafic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Resource-9: instance Elstic IP
resource "aws_eip" "instance-EIP" {
  #vpc      = true
  #domain           = "vpc"
  tags = {
    Name = "Instance-EIP"
  }
}

resource "aws_instance" "bastion" {
  ami                    = "ami-047a51fa27710816e" # Amazon Linux
  instance_type          = "t2.micro"
  key_name               = "my_pair"
  subnet_id              = aws_subnet.vpc-dev-public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.dev-vpc-public-sg.id]
  #user_data = file("apache-install.sh")
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF
  tags = {
    "Name" = "bastion"
    "env"  = "Develop"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.instance-EIP.id
}



