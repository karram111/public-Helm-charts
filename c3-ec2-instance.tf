/*# Resource-8: Create EC2 Instance
resource "aws_instance" "app-dev-01" {
  ami                    = "ami-047a51fa27710816e" # Amazon Linux
  instance_type          = "t2.micro"
  key_name               = "my_pair"
  subnet_id              = aws_subnet.vpc-dev-private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.dev-vpc-private-sg.id]
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
    "Name" = "appserv01"
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
  }
}*/