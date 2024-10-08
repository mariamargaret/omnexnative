# Create an Application Load Balancer
resource "aws_lb" "prodapp_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets           = [aws_subnet.FW-MGMT-security[1].id, aws_subnet.FW-MGMT-security[2].id]

  tags = {

    Name = "prodapp-alb"
	}
  
}


# Create a Target Group
resource "aws_lb_target_group" "prodapp_tg" {
  name        = "prodapp-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Prod-vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }

  tags = {
    Name = "app-tg"
  }
}

# Create a Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.prodapp_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prodapp_tg.arn
  }
}


# Create a Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.Prod-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP or CIDR range
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Register Targets (EC2 instances in this example)
resource "aws_lb_target_group_attachment" "target" {
  target_group_arn = aws_lb_target_group.prodapp_tg.arn
  target_id        = aws_instance.prodapp_server.id  # Replace with your EC2 instance ID
  port             = 80
}
