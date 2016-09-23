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

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: $script

  config.vm.define "server" do |n1|
      n1.vm.hostname = "server"
      n1.vm.network "private_network", ip: "10.10.10.10"

      n1.vm.provision "shell", run: "always", privileged: false,
        inline: "consul agent -ui -server -data-dir /tmp/consul -bind=10.10.10.10 -config-dir /etc/consul.d -client=10.10.10.10 &"
  end

  config.vm.define "service" do |n2|
      n2.vm.hostname = "service"
      n2.vm.network "private_network", ip: "10.10.10.11"

      n2.vm.provision "shell",
        inline: "apt-get update && apt-get install apache2 -y && service apache2 restart"

      n2.vm.provision "shell", run: "always", privileged: false,
        inline: "consul agent -data-dir /tmp/consul -bind=10.10.10.11 -config-dir /etc/consul.d & consul join 10.10.10.10 &"
  end

  config.vm.define "consumer" do |n3|
      n3.vm.hostname = "consumer"
      n3.vm.network "private_network", ip: "10.10.10.12"
  end
end
