resource "aws_instance" "prodapp_server" {
  ami           = var.ami_id
  instance_type = "m5.xlarge"
  subnet_id       = aws_subnet.FW-MGMT-security[0].id
  vpc_security_group_ids = [aws_security_group.prodappsg.id]
  key_name      = "newkey" # Replace with your key pair
  #map_public_ip_on_launch = true
  #associate_public_ip_address = true

  tags = {
    Name = "prodApp-server"
  }
}


# Create a Security Group
resource "aws_security_group" "prodappsg" {
  vpc_id     = aws_vpc.Prod-vpc.id


# Allow RDP access from your IP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
  }

 

  ingress {
    from_port   = 143
    to_port     = 143
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb_sg.id]
  }

 
  # Allow inbound ICMP (ping) traffic from any source
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Allows ping from anywhere, change this if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prodapp-sg"
  }
}


#bastion server
resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = "m5.xlarge"
  subnet_id       = aws_subnet.FW-MGMT-security[3].id
  vpc_security_group_ids = [aws_security_group.appsg.id]
  key_name      = "newkey" # Replace with your key pair
  #map_public_ip_on_launch = true
  associate_public_ip_address = true

  tags = {
    Name = "bastion-server"
  }
}


# Create a Security Group
resource "aws_security_group" "appsg" {
  vpc_id     = aws_vpc.Prod-vpc.id


# Allow RDP access from your IP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
  }

  ingress {
    from_port   = 143
    to_port     = 143
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
  # Allow inbound ICMP (ping) traffic from any source
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Allows ping from anywhere, change this if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastionapp-sg"
  }
}
