#Creating new SNS topic
resource "aws_sns_topic" "cw-alert" {
  name = "MyCloudWatchAlertTopic"
}

#SNS topic subscription
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.cw-alert.arn
  protocol  = "email"
  endpoint  = "test@email.abv"
}

#Configuring the Cloud Watch alarm
resource "aws_cloudwatch_metric_alarm" "my-cw" {
  alarm_name          = "my-cw"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 100
  alarm_description   = "Total request exceeded 100"  
  alarm_actions       = [aws_sns_topic.cw-alert.arn]
  dimensions = {
    LoadBalancer = aws_lb.my-lb.arn_suffix
  }
  depends_on          = [aws_lb.my-lb]
}