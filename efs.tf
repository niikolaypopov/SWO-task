#Seting up the File system
resource "aws_efs_file_system" "my-efs" {
  creation_token = "my-efs"
  encrypted      = true
  tags = {
    Name = "My-EFS"
  }
}

#Mount target for the file system. Attaching it to the subnet1 and the security group where the instances are
resource "aws_efs_mount_target" "efs-mnt" {
  file_system_id  = aws_efs_file_system.my-efs.id
  subnet_id       = aws_subnet.subnet1.id
  security_groups = [aws_security_group.my-srv-sg.id]
}