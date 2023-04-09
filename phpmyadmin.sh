#!/bin/bash

Help()
{
	echo "Usage : phpmyadmin container_id"
	echo
}

Help

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

for port in $(seq 4444 65000); do echo -ne "\035" | telnet 127.0.0.1 $port > /dev/null 2>&1; [ $? -eq 1 ] && echo "unused port found : $port" && break; done
container_network=$(docker inspect $1 --format='{{range $k,$v := .NetworkSettings.Networks}} {{$k}} {{end}}')
container_name=$(docker inspect --format="{{.Name}}" $1)
container_name="phpmyadmin-${container_name/\//}"
docker run -d --name $container_name -e PMA_HOST=$1 -p $port:80 phpmyadmin
docker network connect $container_network $container_name
echo "PhpMyadmin running : http://$(curl -s ifconfig.me):$port"
