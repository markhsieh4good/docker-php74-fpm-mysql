# docker-php74-fpm-mysql

## how to work.
```
[install docker env]
bash ./install_docker.sh

[create network custom dev]
docker network create demo-bridge

[start/stop/monitor/log programs]
docker-compose -f docker-compose.yml start/stop/ps/logs

[!!!mac]
因為裝了 docker desktop 之後會自動安裝docker-compose，請用以下方式執行
/usr/local/bin/docker-compose -f docker-com.....
```
## env (會直接存在或自動生成)
```
mysql_custom_configuration_80
~ 放 my.ini 設定

mysql_custom_system
~ 系統檔案，生成後不要去修改

nginx_common_webs
~ 放 nginx 預設首頁的內容，沒必要不用動

php_custom_nginx_conf
~ 放 nginx 設定，default.conf and service.conf 建議不要更動
~ default.conf 可以直接配合container的localhost使用php-fpm支援，後續說明
~ service.conf 是設定給php-cli自行開啟sample web-server時轉只用，後續說明

```
## link to project

### docker-compose
> docker-compose.yml
```
  demo.php-api: 
    #build: ./env/nginx-php-fpm-74 
    image: "php-fpm-nginx:7.4-modify" 
    container_name: demo.php-api 
    volumes: 
      - ./nginx_common_webs:/usr/share/nginx/html 
      - ./php_custom_nginx_conf:/etc/nginx/sites-available
      ## php-fpm  <---  對應到 default.conf 的nginx 設定
      - ../project:/var/www/html
      ## php-cli  <---  對應到 server.conf 的nginx 設定
      - ../service:/opt/service
      ## other apps
      - ./app:/opt/app
    ports: 
      - 18440:80 
      - 18441:8000 
```
基本上建議手動去生成 php-fpm/php-cli 環境，但是你也可以把 "#build: "去除註解來啟動 docker-compose build
```
手動生成images
cd ./env/nginx-php-fpm-74 
docker build -t php-fpm-nginx:7.4-modify .
yes | docker system prune

可能會把network dev 刪除，所以要再生成一次
docker network create demo-bridge
```
### php cli
```
- ../service:/opt/service
```
允許讀取此專案同一個 父資料夾路徑(parent folder/path) <br/>
名稱預設是service ，有需要自行修改 <br/>
service 需要有 howtostart 這個檔案，裡面只接受一行指令 <br/>
可以多寫一個bash file 來啟用操作。 <br/>
以下是參考
```
#!/bin/bash

echo "========== composer checking ============"
composer clearcache
composer install
composer update
composer fund

echo "========== renew logrotate setting ============"
cp ./php_cli /etc/logrotate.d/
logrotate /etc/logrotate.conf

echo "========== prepare start service ============="
if [ ! -e "/var/log/php-cli" ]; then
    mkdir -p /var/log/php-cli
fi 
if [ ! -e "/var/log/php-cli/service.log" ]; then
    touch /var/log/php-cli/service.log
fi 
if [ ! -e "/var/log/php-cli/error.log" ]; then
    touch /var/log/php-cli/error.log
fi 

echo "========== ready to start service =============="
cd config
sed -i "s/'hostname'.*/'hostname'        => 'hello.deom',/g" database.php
sed -i "s/'host'.*/'host'	=>	'demo.redis',/g" cache.php
cd ..

## 以下是 php think 結構下範例，一定要把 web-server port 開在 8001
## 可以讓 server.conf 直接從 http://127.0.0.1:8000 轉址到 8001
nohup php think run --port 8001 3>&1 2>>/var/log/php-cli/error.log | tee -a /var/log/php-cli/service.log &
```
### php-fpm
```
- ../project:/var/www/html
```
允許讀取此專案同一個 父資料夾路徑(parent folder/path) <br/>
名稱預設是service ，有需要自行修改 <br/>
資料夾下一定要有 index.php

### other app suppert
```
- ./app:/opt/app
```
允許讀取此專案同一個 父資料夾路徑(parent folder/path) <br/>
名稱預設是 app ，有需要自行修改 <br/>
app 需要有 howtostart 這個檔案，裡面只接受一行指令 <br/>
可以多寫一個bash file 來啟用操作。

### 客製化的nginx config
```
- ./php_custom_nginx_conf:/etc/nginx/sites-available
```
會自動建立linker 到 /etc/nginx/sites-enable <br/>
docker-compose 啟動的資訊會顯示出要運作的設定。

## support php req.
> 系統 base
[7.4/bullseye/fpm/Dockerfile](https://github.com/docker-library/php/blob/41d3146c41fc26fc6768a44a75ab59f6a392f28e/7.4/bullseye/fpm/Dockerfile)
```
php:7.4.24-fpm

```
> 區碼
```
軟體：locales
設定：
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
    
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

```
> 安裝開發函示庫
[請見 Dockerfile](./env/nginx-php-fpm-74/Dockerfile) <br />
> php 延伸功能
[請見 Dockerfile](./env/nginx-php-fpm-74/Dockerfile) <br />
> php composer 
```
    composer (已經綁定動作，可用 -h 查驗支援細節)
```
> entrypoint.sh<br/>
> 決定啟動後要怎樣使用 supervisor 或啟動什麼功能。預設是用nginx 綁定系統持續運行。 

## support Database
> mysql admin-web<br/>
> redis<br/>
> [https://hub.docker.com/_/mysql]: https://hub.docker.com/_/mysql
> <br/>
> account: <br/>
> root
> TUHn3KasG=gw
