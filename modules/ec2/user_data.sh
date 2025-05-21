#!/bin/bash
# Update hệ thống
yum update -y

# Cài nginx
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx

# Ghi log kiểm tra
echo "Nginx installed at $(date)" >> /var/log/userdata.log