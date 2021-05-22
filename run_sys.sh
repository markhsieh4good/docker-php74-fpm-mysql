#!/bin/bash

## global var.
SUPERTAGET=""

function system() {
  ## ref.: https://stackoverflow.com/a/8597411
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SUPERTAGET="sudo"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    SUPERTAGET=""
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    SUPERTAGET=""
  elif [[ "$OSTYPE" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    SUPERTAGET=""
  elif [[ "$OSTYPE" == "win32" ]]; then
    # I'm not sure this can happen.
    SUPERTAGET=""
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    SUPERTAGET="sudo"
  else
    # Unknown.
    echo "unknown os env. ---> $OSTYPE"
  fi
}

function networks() {
  CHKNETWORK=`"$SUPERTAGET" docker network ls`
  CHKBRIDGE=`echo "$CHKNETWORK" | grep fruit-bridge`

  if [ -z "$CHKBRIDGE" ] || [ "$CHKBRIDGE" == "" ]; then
    /"$SUPERTAGET" docker network create --driver bridge fruit-bridge
  else
    "$SUPERTAGET" docker network ls | grep -E "fruit-bridge"
  fi
}

function folders() {
  _PWD=`pwd`
  mkdir -p "$_PWD/mysql_custom_system"
  mkdir -p "$_PWD/mysql_custom_configuration_80"
  mkdir -p "$_PWD/php_custom_final_web"
  mkdir -p "$_PWD/php_custom_nginx_conf"
}

function update() {
  #expand -t 1 docker-compose.yml > temp.yml
  #rm docker-compose.yml
  #mv ./temp.yml docker-compose.yml

  l_IMG=`sudo docker images | grep 'php-fpm-nginx' | grep '7.4-modify'`
  l_PWD=`pwd`
  if [ -z "$l_IMG" ]; then
    cd  ./env/nginx-php-fpm-74
    sudo docker build -t php-fpm-nginx:7.4-modify .
    sleep 2
    cd "$l_PWD"
  fi 

  sleep 2

  "$SUPERTAGET" docker-compose -f docker-compose.yml down
  sleep 3
  "$SUPERTAGET" docker-compose -f docker-compose.yml build
  "$SUPERTAGET" docker-compose -f docker-compose.yml up -d
  sleep 3
  "$SUPERTAGET" docker-compose -f docker-compose.yml ps
}

function main() {
  system
  networks
  folders
  update
}

main
