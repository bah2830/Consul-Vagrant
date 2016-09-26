# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell", path: "vagrant_setup/common.sh", preserve_order: true

  config.vm.define "node1" do |n1|
      n1.vm.hostname = "node1"
      n1.vm.network "private_network", ip: "10.10.10.10"

      n1.vm.provision "shell", run: "always", path: "vagrant_setup/node1.sh", preserve_order: true
  end

  config.vm.define "node2" do |n2|
      n2.vm.hostname = "node2"
      n2.vm.network "private_network", ip: "10.10.10.11"

      n2.vm.provision "shell", run: "always", path: "vagrant_setup/node2.sh", preserve_order: true
  end

  config.vm.define "node3" do |n3|
      n3.vm.hostname = "node3"
      n3.vm.network "private_network", ip: "10.10.10.12"

      n3.vm.provision "shell", run: "always", path: "vagrant_setup/node3.sh", preserve_order: true
  end
end
