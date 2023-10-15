#Creating publicly innaccesible RDS instance 
resource "aws_db_instance" "my-db" {
  allocated_storage      = 20
  identifier             = "my-db"
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "wordpress"
  username               = "admin"
  password               = "rootpass"
  parameter_group_name   = "default.mysql5.7"
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  availability_zone      = aws_subnet.subnet3.availability_zone
}