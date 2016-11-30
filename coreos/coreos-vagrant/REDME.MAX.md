export DOCKER_HOST=tcp://localhost:2375

docker ps (connect to 2375 host)

docker-compose up (host:2375)
docker exec -i -t projectx_php_1 bash -c 'cd /var/www/app/ && ln -sf /vendor /var/www/app/vendor && composer install'
docker exec -i -t projectx_php_1 bash -c 'cd /var/www/app/ && ln -sf /vendor /var/www/app/vendor && composer install'



 docker network create   --subnet=172.19.0.0/16 mynet
