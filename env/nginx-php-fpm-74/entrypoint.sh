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

if [ -e "/etc/service/howtostart" ]; then
  CMD=`cat /etc/service/howtostart | head -1`
  if [ ! -e "/var/log/service.log" ]; then
    touch /var/log/service.log
  fi 
  /bin/bash -c "cd /etc/service && $CMD" &
fi

nginx -g "daemon off;"
