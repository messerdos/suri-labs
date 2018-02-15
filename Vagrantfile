# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "opentable/win-2012r2-standard-amd64-nocm"
  config.vbguest.auto_update = true
  config.vm.hostname = "client"
  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = true
  config.vm.network "private_network", ip: "172.25.0.21"
  config.vm.provision "shell", path: "provisioning/provision.ps1", privileged: true
end


