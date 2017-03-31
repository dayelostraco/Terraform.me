#!/bin/bash
set -e

echo "Installing nginx"
yum install -y nginx

cat <<EOF > /etc/nginx/nginx.conf
${nginx_conf}
EOF

service nginx restart
chkconfig nginx on
