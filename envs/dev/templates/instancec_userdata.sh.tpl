#!/bin/bash
set -o nounset # treat unset variables as an error and exit immediately.
set -o errexit # exit immediately when a command fails.

sudo apt-get update
sudo apt-get install -y pass unzip nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo '<!doctype html>
<html lang="en"><h1>Register!</h1></br>
<h3>(Instance C)</h3>
</html>' | sudo tee /var/www/html/index.html
echo 'server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location /register/ {
            alias /var/www/html/;
            index index.html;
        }
        location / {
            try_files $uri $uri/ =404;
        }
    }' | sudo tee /etc/nginx/sites-available/default
sudo systemctl reload nginx
