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
