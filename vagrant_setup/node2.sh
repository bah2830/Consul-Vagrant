rm -rf /home/vagrant/consul/node2
mkdir -p /home/vagrant/consul/node2

echo '{
  "bootstrap": false,
  "server": true,
  "datacenter": "test",
  "bind_addr": "10.10.10.11",
  "start_join": ["10.10.10.10"]
}' >> /home/vagrant/consul/node2/config.json

echo '{
    "service": {
        "name": "apache",
        "tags": [
            "web"
        ],
        "port": 80,
        "check": {
            "script": "curl 10.10.10.11 > /dev/null 2>&1",
            "interval": "10s"
        }
    }
}' >> /home/vagrant/consul/node2/apache.json

echo '{
    "service": {
        "name": "redis",
        "tags": [
            "web"
        ],
        "port": 6379,
        "check": {
            "tcp": "10.10.10.11:6379",
            "interval": "10s",
            "timeout": "3s"
        }
    }
}' > /home/vagrant/consul/node2/redis.json

docker rm -f redis
docker rm -f apache
docker rm -f consul

docker run -d --name="apache" -p 80:80 php:5.6-apache
docker run -d --name="redis" -p 6379:6379 redis:3.2.4-alpine
docker run -d --name="consul" -h node2 --net="host" -v /home/vagrant/consul/node2:/consul/config consul agent