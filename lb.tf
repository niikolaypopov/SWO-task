#Load Balancer
resource "aws_lb" "my-lb" {
  name               = "my-lb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-srv-sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  depends_on         = [aws_internet_gateway.my-gw]
  tags = {
    Name = "my-alb"
  }
}

#Target group creating
resource "aws_lb_target_group" "my-tg" {
  health_check {
    interval            = 10
    path                = "/wp-admin/install.php"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}


resource "aws_lb_listener" "aws_lb_listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.my-tg.arn
    type             = "forward"
  }
}