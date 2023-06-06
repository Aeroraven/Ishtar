echo "Starting MySQL"
MYSQL_PASSWORD="114514"
docker run -d --privileged=true \
	--name wpdatabase \
	-v /data/mysql:/var/lib/mysql \
	-e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
	-e MYSQL_DATABASE=wordpress \
	-p 3306:3306 \
	mysql:latest
MYSQL_IP=$(docker inspect -f '{{.Name}} {{.NetworkSettings.IPAddress }}' $(docker ps -aq) | grep wpdatabase | awk '{print $2}')
echo "MySQL IP="$MYSQL_IP
echo "Starting WP"
docker run -d -p 6498:80 \
	--link wpdatabase \
	-e WORDPRESS_DB_HOST=$MYSQL_IP":3306" \
	-e WORDPRESS_DB_USER=root \
	-e WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD \
	-e MYSQL_DATABASE=wordpress \
	-v $(pwd)"/wp-demo/www/html":/var/www/html \
	wordpress:latest
