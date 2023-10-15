#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo amazon-linux-extras install php7.2 -y
cd /var/www/html
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
mv wordpress/* /var/www/html
rm latest.zip
mv wp-config-sample.php wp-config.php
sudo yum install jq -y
export rds_db_name=$(aws ssm get-parameter --name "rds-db-name" --region eu-west-1 | jq -r .Parameter.Value)
export rds_db_username=$(aws ssm get-parameter --name "rds-username" --region eu-west-1 | jq -r .Parameter.Value)
export rds_db_password=$(aws ssm get-parameter --name "rds-password" --with-decryption --region eu-west-1 | jq -r .Parameter.Value)
export rds_db_endpoint=$(aws ssm get-parameter --name "rds-endpoint" --region eu-west-1 | jq -r .Parameter.Value)
sed "s#database_name_here#$rds_db_name#g" -i wp-config.php
sed "s#username_here#$rds_db_username#g" -i wp-config.php
sed "s#password_here#$rds_db_password#g" -i wp-config.php
sed "s#localhost#$rds_db_endpoint#g" -i wp-config.php
echo $rds_db_endpoint > file.log
sudo systemctl start httpd.service
sudo yum install nfs-utils -y
sudo mkdir /home/ec2-user/efs
cd /home/ec2-user
export efs_mount=$(aws ssm get-parameter --name "efs-mount" --region eu-west-1 | jq -r .Parameter.Value)
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $(aws ssm get-parameter --name "efs-mount" --region eu-west-1 | jq -r .Parameter.Value):/ efs
cd /home/ec2-user/efs
sudo su
echo $efs_mount > test.txt