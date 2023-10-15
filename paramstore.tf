#Sending RDS detail to Parameter Store so I can invoke them on the instances and use them for the wp-config.php file
resource "aws_ssm_parameter" "db_name" {
  depends_on = [aws_db_instance.my-db]
  name       = "rds-db-name"
  type       = "String"
  value      = aws_db_instance.my-db.db_name
}

resource "aws_ssm_parameter" "username" {
  depends_on = [aws_db_instance.my-db]
  name       = "rds-username"
  type       = "String"
  value      = aws_db_instance.my-db.username
}

resource "aws_ssm_parameter" "password" {
  depends_on = [aws_db_instance.my-db]
  name       = "rds-password"
  type       = "SecureString"
  value      = aws_db_instance.my-db.password
}

resource "aws_ssm_parameter" "endpoint" {
  depends_on = [aws_db_instance.my-db]
  name       = "rds-endpoint"
  type       = "String"
  value      = aws_db_instance.my-db.endpoint
}

#Sending EFS mount target dns name to Parameter store so I can invoke it on the instances and run the command using user_data
resource "aws_ssm_parameter" "efs_mount" {
  depends_on = [aws_efs_file_system.my-efs]
  name       = "efs-mount"
  type       = "String"
  value      = aws_efs_mount_target.efs-mnt.dns_name
}