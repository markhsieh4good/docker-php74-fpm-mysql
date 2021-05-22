#!/bin/bash
echo "stop below system ... "
sudo docker-compose -f docker-compose.yml ps
sleep 1
sudo docker-compose -f docker-compose.yml down
echo ""
sleep 1
echo "clean image from custom ... "
sleep 1
sudo docker rmi php-fpm-nginx:7.4-modify
