# docker-php74-fpm-mysql

## how to work.
```
[install docker env]
bash ./install_docker.sh
[run docker base testing env]
bash ./run_sys.sh
[stop and clean testing env]
bash ./stop_sys.sh
```
## env
```
mysql_custom_configuration_80
放 my.ini 設定
mysql_custom_system
系統檔案，生成後不要去修改
php_custom_final_web
放 nginx 預設首頁的內容
php_custom_nginx_conf
放 nginx 設定
```
## support php req.
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
```
library: 
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libssl-dev \
    libmemcached-dev \
    libz-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libxml2-dev \
    libcurl3-dev \
    libedit-dev \
    libpspell-dev \
    libldap2-dev \
    unixodbc-dev \
    libpq-dev \
    libzip-dev
```
> 通用工具
```
    wget \
    vim \
    git \
    net-tools \
    curl \
    supervisor \
    tofrodos \
    zip \
    unzip \
    openssl
```
> php 延伸功能
```
原生：docker-php-ext-install
zip json mysqli pdo pdo_mysql
三方：install-php-extensions
protobuf swoole openssl redis
```
> php composer 
```
    composer (已經綁定動作，可用 -h 查驗支援細節)
```
> entrypoint.sh<br/>
> 決定啟動後要怎樣使用 supervisor 或啟動什麼功能。預設是用nginx 綁定系統持續運行。 

## support Database
> mysql admin-web(simple php-myAdmin)<br/>
> redis<br/>
> [https://hub.docker.com/_/mysql]: https://hub.docker.com/_/mysql
