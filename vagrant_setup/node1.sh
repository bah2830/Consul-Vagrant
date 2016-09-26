rm -rf /home/vagrant/consul/node1
mkdir -p /home/vagrant/consul/node1

echo '{
  "bootstrap": true,
  "server": true,
  "ui": true,
  "datacenter": "test",
  "bind_addr": "10.10.10.10",
  "client_addr": "0.0.0.0"
}' >> /home/vagrant/consul/node1/config.json

docker rm -f consul
docker run -d --name="consul" -h node1 --net="host" -v /home/vagrant/consul/node1:/consul/config consul agent