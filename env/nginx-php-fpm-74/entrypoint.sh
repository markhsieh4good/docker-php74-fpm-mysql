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
rm /etc/nginx/site-enabled/*

if [ -e "/opt/service/howtostart" ]; then
  CMD=`cat /opt/service/howtostart | head -1`
  /bin/bash -c "cd /opt/service && $CMD" &
fi

if [ -e "/etc/nginx/sites-available/default.conf" ]; then
  ln -s /etc/nginx/sites-available/default.conf /etc/nginx/conf.d/default.conf
fi

for f in `ls -a /etc/nginx/sites-available/`
do
  _NAME=`echo "$f" | xargs basename`
  if [[ "$f" == "default.conf" ]]; then
    echo ""
  else
    ln -s "$f" /etc/nginx/sites-enabled/"$_NAME"
  fi
done

echo "======== ready to start nginx ==========="
ls -alh /etc/nginx/sites-enabled/
echo "-----------------------------------------"
nginx -g "daemon off;"
