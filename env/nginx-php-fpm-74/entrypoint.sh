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

if [ -e "/opt/service/howtostart" ]; then
  CMD=`cat /opt/service/howtostart | head -1`
  /bin/bash -c "cd /opt/service && $CMD" &
fi

nginx -g "daemon off;"
