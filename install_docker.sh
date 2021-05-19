#!/bin/bash

function system() {
  echo "linux/unix only"
  ## ref.: https://stackoverflow.com/a/8597411
  SUPERTAGET=1
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SUPERTAGET=0
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    SUPERTAGET=1
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    SUPERTAGET=1
  elif [[ "$OSTYPE" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    SUPERTAGET=1
  elif [[ "$OSTYPE" == "win32" ]]; then
    # I'm not sure this can happen.
    SUPERTAGET=1
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    SUPERTAGET=0
  else
    # Unknown.
    echo "unknown os env. ---> $OSTYPE"
  fi
  return $SUPERTAGET
}

function docker_install() {
    echo "update env. "
    sudo yum update -y
    sudo yum install -y yum-utils
    sudo yum install -y git
    sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

    echo "you can use below command, if you need to choice the newest docker-ce version"
    echo "yum list docker-ce --showduplicates | sort -r"
    echo "example :"
    echo "docker-ce.x86_64            3:18.09.9-3.el7                    @docker-ce-stable
docker-ce.x86_64            3:18.09.8-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.7-3.el7                    docker-ce-stable"
    echo "choice [x86_64, 3:**, docker-ce-stable] ..."
    echo "3:18.09.9-3.el7 --> version 18.09.9"
    echo ""
    echo "Here will wait 5 sec. for repentance."
    sleep 5

    echo "install docker ce ... we choice 18.09.1 (might be updated by system.)"
    sudo yum install -y docker-ce-18.09.1 docker-ce-cli-18.09.1 containerd.io
    sleep 1
    
    if [ ! -e "/etc/docker" ]; then
        sudo mkdir -p /etc/docker
        sudo cp ./daemon.json /etc/docker/
    elif [ ! -e "/etc/docker/daemon.json" ]; then
        sudo cp ./daemon.json /etc/docker/
    else
        echo "already add daemon.json"
    fi
    cat /etc/docker/daemon.json

    sleep 2
    sudo systemctl start docker
    sudo systemctl enable docker
}

function docker_uninstall() {
    echo "stop & remove running docker container ..."
    sudo docker stop $(sudo docker ps -a -q)
    sudo docker rm $(sudo docker ps -a -q)
    sleep 1
    sudo service stop docker
    sleep 1
    echo "uninstall old version ... "
    sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
    
}

function docker_remove_ce() {
    echo "uninstall docker ce ... ?"
    sudo yum remove -y docker-ce-18.09.1 docker-ce-cli-18.09.1 containerd.io
    if [ $? -eq 1 ]; then
        echo "fail to remove docker-ce 18.09.1 ... just remove default choice tag ..."
        sudo yum remove -y docker-ce docker-ce-cli containerd.io
    fi
}

function install_docker_compose() {
    echo "install docker-compose v1.28.5 ... if it's not exist ... "
    if [ -e "/usr/local/bin/docker-compose" ]; then
        echo "docker_compose already installed ... "
        docker-compose --version
    else
        sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
        docker-compose --version
    fi
    echo ""
}


function install_docker() {
    echo "install docker system ... "
    echo -n "your current docker server/client version is:"
    sudo docker version
    if [ $? -gt 0 ]; then
        echo "system cannot find any running docker server! Did it not been installed or service not running?"
        echo ""
        exit 1
    fi
    echo "Our company recommends using more than version 18.x.x "
    read -p "Do you accept to install docker server (18.09.1)? yes, re-install or No! (y/r/N): " answer
    if [ "$answer" == 'y' ] || [ "$answer" == 'Y' ]; then
        docker_uninstall
        docker_install
    elif [ "$answer" == 'r' ] || [ "$answer" == 'R' ]; then
        docker_remove_ce
        docker_install
    else
        echo ""
    fi
}

function install_nginx() {

    echo "install nginx ... "
    _CHKNGX=`ps -ef | grep "nginx -g daemon off" | grep -v 'grep'`
    _CHKSER=`sudo systemctl | grep nginx | awk '{print $1}'`
    if [ -z "$_CHKNGX" ] && [ -z "$_CHKSER" ]; then
        echo "There is no running nginx server here ... you need to install or turn on first."
        sudo service nginx start
        if [ $? -eq 0 ]; then
            echo "successs ..."
        else
            sudo yum install -y nginx
        fi
        sleep 1
        update_nginx_conf
    else
        update_nginx_conf
    fi
    echo ""
}

function main() {
    system
    if [ $? -ne 0 ]; then
      echo "not support"
      exit 1
    fi
    install_docker
    install_docker_compose
    install_nginx
}

main
