rm -rf /home/vagrant/consul/node3
mkdir -p /home/vagrant/consul/node3

echo '{
  "bootstrap": false,
  "server": false,
  "datacenter": "test",
  "bind_addr": "10.10.10.12",
  "start_join": ["10.10.10.10"]
}' >> /home/vagrant/consul/node3/config.json

echo '{
    "service": {
        "name": "apache",
        "tags": [
            "web"
        ],
        "port": 80,
        "check": {
            "script": "curl 10.10.10.12 > /dev/null 2>&1",
            "interval": "10s"
        }
    }
}' >> /home/vagrant/consul/node3/apache.json

echo '{
    "service": {
        "name": "mysql",
        "tags": [
            "web"
        ],
        "port": 3306
    }
}' >> /home/vagrant/consul/node3/mysql.json

echo '{
    "service": {
        "name": "redis",
        "tags": [
            "web"
        ],
        "port": 6379
    }
}' > /home/vagrant/consul/node3/redis.json

docker rm -f redis
docker rm -f apache
docker rm -f consul
docker rm -f mysql

docker run -d --name="apache" -p 80:80 php:5.6-apache
docker run -d --name="consul" -h node3 --net="host" -v /home/vagrant/consul/node3:/consul/config consul agent