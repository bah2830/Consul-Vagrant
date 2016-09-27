# Consul Proof Of Concept

Simple vagrant environment for testing consul in a cluster.


### Prerequisites
* Vagrant
* Virtual box


### Setup
```
vagrant up
```

Interface will be hosted at http://10.10.10.10:8500/ui



### Testing Failover
SSH into one of the nodes with a running service
```
vagrant ssh node3
```

Shutdown a container
```
docker stop redis
```
