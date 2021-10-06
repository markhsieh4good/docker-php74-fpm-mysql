#!/bin/bash

_PWD=`pwd`
echo -n "===== start bash == "
date "+%Y/%m/%d %H:%M:%S"
echo ""

echo "====== clear old nginx setting ======"
if [ -e "/etc/nginx/conf.d/default.conf" ]; then
  rm /etc/nginx/conf.d/default.conf
fi
if [ -e "/etc/nginx/sites-enabled/default" ]; then
  rm /etc/nginx/sites-enabled/default
fi
cd /etc/nginx/sites-enabled/
for f in `ls -a ./`
do
  if [ "$f" == "." ]; then
    echo ""
  elif [ "$f" == ".." ]; then
    echo ""
  else
    echo "rm $f"
    rm "$f"
  fi
done
cd "$_PWD"
echo ""

echo "====== php-cli support ======="
if [ -e "/opt/service/howtostart" ]; then
  CMD=`cat /opt/service/howtostart | head -1`
  /bin/bash -c "cd /opt/service && $CMD"
fi
echo ""

echo "====== supervisor======"
service supervisor stop
sleep 1
service supervisor start
service supervisor status
sleep 2
echo ""
ps aux | grep "php-fpm" | grep "process"
echo ""

echo "======= nginx setting ======="
if [ -e "/etc/nginx/sites-available/default.conf" ]; then
  ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/conf.d/default
fi

cd /etc/nginx/sites-available/
for f in `ls -a ./`
do
  _NAME=`echo "$f" | xargs basename`
  if [[ "$f" == "default.conf" ]]; then
    echo ""
  elif [ "$f" == "." ]; then
    echo ""
  elif [ "$f" == ".." ]; then
    echo ""
  else
    echo "ln -s /etc/nginx/sites-available/$f /etc/nginx/sites-enabled/$_NAME"
    ln -s "/etc/nginx/sites-available/$f" /etc/nginx/sites-enabled/"$_NAME"
  fi
done
cd "$_PWD"
echo ""

echo "======== ready to start nginx ==========="
ls -alh /etc/nginx/sites-enabled/
echo "-----------------------------------------"
nginx -g "daemon off;"
