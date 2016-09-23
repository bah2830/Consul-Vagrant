# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo Installing dependencies...
sudo apt-get update
sudo apt-get install -y unzip curl

echo Fetching Consul...
cd /tmp/
curl https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip -o consul.zip

echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d
SCRIPT

$server_setup = <<SCRIPT
echo '{
  "bootstrap": true,
  "server": true,
  "ui": true,
  "datacenter": "home",
  "data_dir": "/tmp/consul",
  "bind_addr": "10.10.10.10",
  "client_addr": "10.10.10.10",
  "log_level": "INFO",
  "enable_syslog": true
}' >> /etc/consul.d/config.json
SCRIPT

$service1_setup = <<SCRIPT
apt-get install apache2 -y && service apache2 restart

echo '{
  "bootstrap": false,
  "server": true,
  "datacenter": "home",
  "data_dir": "/tmp/consul",
  "bind_addr": "10.10.10.11",
  "start_join": ["10.10.10.10"],
  "log_level": "INFO",
  "enable_syslog": true
}' >> /etc/consul.d/config.json

echo '{
    "check": {
        "name": "internet",
        "script": "ping -c1 google.com > /dev/null",
        "interval": "30s"
    }
}' > /etc/consul.d/internet.json

echo '{
    "service": {
        "name": "web",
        "tags": [
            "web"
        ],
        "port": 80,
        "check": {
            "script": "curl localhost > /dev/null 2>&1",
            "interval": "10s"
        }
    }
}' > /etc/consul.d/web.json
SCRIPT

$service2_setup = <<SCRIPT
apt-get install apache2 mysql-server -y
service mysql restart
service apache2 restart


echo '{
  "bootstrap": false,
  "server": true,
  "datacenter": "home",
  "data_dir": "/tmp/consul",
  "bind_addr": "10.10.10.12",
  "start_join": ["10.10.10.10"],
  "log_level": "INFO",
  "enable_syslog": true
}' >> /etc/consul.d/config.json

echo '{
    "check": {
        "name": "internet",
        "script": "ping -c1 google.com > /dev/null",
        "interval": "30s"
    }
}' > /etc/consul.d/internet.json

echo '{
    "service": {
        "name": "web",
        "tags": [
            "web"
        ],
        "port": 80
    }
}' > /etc/consul.d/web.json

echo '{
    "service": {
        "name": "mysql",
        "tags": [
            "web"
        ],
        "port": 3306
    }
}' > /etc/consul.d/mysql.json

echo '{
    "service": {
        "name": "redis",
        "tags": [
            "web"
        ],
        "port": 6379
    }
}' > /etc/consul.d/redis.json
SCRIPT

$service3_setup = <<SCRIPT
apt-get install apache2 redis-server -y
service apache2 restart
service redis-server restart

echo '{
  "bootstrap": false,
  "server": true,
  "datacenter": "home",
  "data_dir": "/tmp/consul",
  "bind_addr": "10.10.10.13",
  "start_join": ["10.10.10.10"],
  "log_level": "INFO",
  "enable_syslog": true
}' >> /etc/consul.d/config.json

echo '{
    "check": {
        "name": "internet",
        "script": "ping -c1 google.com > /dev/null",
        "interval": "30s"
    }
}' > /etc/consul.d/internet.json

echo '{
    "service": {
        "name": "web",
        "tags": [
            "web"
        ],
        "port": 80
    }
}' > /etc/consul.d/web.json

echo '{
    "service": {
        "name": "redis",
        "tags": [
            "web"
        ],
        "port": 6379
    }
}' > /etc/consul.d/redis.json
SCRIPT


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: $script, preserve_order: true

  config.vm.define "node0" do |n1|
      n1.vm.hostname = "node0"
      n1.vm.network "private_network", ip: "10.10.10.10"

      n1.vm.provision "shell", inline: $server_setup, preserve_order: true
      n1.vm.provision "shell", run: "always", privileged: false, preserve_order: true,
        inline: "consul agent -config-dir /etc/consul.d >> /dev/null &"
  end

  config.vm.define "node1" do |n2|
      n2.vm.hostname = "node1"
      n2.vm.network "private_network", ip: "10.10.10.11"

      n2.vm.provision "shell", inline: $service1_setup, preserve_order: true
      n2.vm.provision "shell", run: "always", privileged: false, preserve_order: true,
        inline: "consul agent -config-dir /etc/consul.d >> /dev/null &"
  end

  config.vm.define "node2" do |n2|
      n2.vm.hostname = "node2"
      n2.vm.network "private_network", ip: "10.10.10.12"

      n2.vm.provision "shell", inline: $service2_setup, preserve_order: true
      n2.vm.provision "shell", run: "always", privileged: false, preserve_order: true,
        inline: "consul agent -config-dir /etc/consul.d >> /dev/null &"
  end

  config.vm.define "node3" do |n2|
      n2.vm.hostname = "node3"
      n2.vm.network "private_network", ip: "10.10.10.13"

      n2.vm.provision "shell", inline: $service3_setup, preserve_order: true
      n2.vm.provision "shell", run: "always", privileged: false, preserve_order: true,
        inline: "consul agent -config-dir /etc/consul.d >> /dev/null &"
  end
end
