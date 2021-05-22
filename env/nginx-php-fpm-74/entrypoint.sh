#!/bin/bash

echo -n "===== start bash == "
date "+%Y/%m/%d %H:%M:%S"
echo ""

if [ -e "/etc/nginx/conf.d/default.conf" ]; then
  rm /etc/nginx/conf.d/default.conf
fi
if [ -e "/etc/nginx/site-enabled/default" ]; then
  rm /etc/nginx/site-enabled/default
fi

nginx -g "daemon off;"
