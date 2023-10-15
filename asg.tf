#Configuration for launch template
resource "aws_launch_template" "my-lt" {
  name          = "my-lt"
  image_id      = "ami-0a7abae115fc0f825"
  instance_type = "t2.micro"
  key_name      = "nn-terraform"
  user_data     = filebase64("./user_data.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile1.name
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.subnet1.id
    security_groups             = [aws_security_group.my-srv-sg.id]
  }
  depends_on = [aws_db_instance.my-db]
}

#Configuration of ASG
resource "aws_autoscaling_group" "my-asg" {
  name                      = "my-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.my-tg.arn]
  vpc_zone_identifier       = [aws_subnet.subnet1.id]

  launch_template {
    id      = aws_launch_template.my-lt.id
    version = aws_launch_template.my-lt.default_version
  }

  tag {
    key                 = "Name"
    value               = "my-srv"
    propagate_at_launch = true
  }
  depends_on = [aws_db_instance.my-db]
}

#Attaching ASG to Target group
resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.my-asg.id
  lb_target_group_arn    = aws_lb_target_group.my-tg.arn
}