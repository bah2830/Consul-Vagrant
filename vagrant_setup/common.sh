curl -sSL https://get.docker.com/ | sh
usermod -aG docker vagrant

curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

if [ ! -d /home/vagrant/consul ]; then
  mkdir -p /home/vagrant/consul;
fi