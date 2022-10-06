#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo echo "<html><body bgcolor=gray><center><h1>WebServer with IP $myip</h1><br>Build by Terraform using external user data, the user data was launched in `pwd`</center></body></html>" > /var/www/html/index.html
sudo service httpd start