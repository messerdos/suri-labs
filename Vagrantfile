# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Path where the extra disks should be stored when using VirtualBox
  vbox_vm_path = ""
  # Memory configuration
  server_memory = 1024 # Recommended: 1024 MiB / Minimum: 512 MiB
  extra_disk_size = 2 # Recommended: 10 GiB / Minimum: 2 GiB

  # Don't modify beyond here
  conname = "Wired connection 1"
  devname = "eth1"

  config.vm.define :mikrotik do |mikrotik|
    mikrotik.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--usb", "on"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
    end
    mikrotik.vm.box = "dulin/mikrotik"
    mikrotik.vm.hostname = "mikrotik"
    mikrotik.ssh.username = "vagrant"
    mikrotik.ssh.password = "vagrant"
    mikrotik.ssh.keys_only = false
    mikrotik.ssh.insert_key = false
    mikrotik.vm.network "private_network", ip: "172.25.0.254", auto_config: false
    mikrotik.vm.network "private_network", ip: "172.16.0.254", auto_config: false
    mikrotik.vm.box_check_update = false
    mikrotik.vbguest.auto_update = false
    mikrotik.vm.synced_folder ".", "/vagrant", disabled: true
    # Enable provisioning with Ansible.
    mikrotik.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/main.yml"
      ansible.verbose = "v"
      ansible.sudo = false
      ansible.host_vars = {
        "mikrotik" => {
          "ansible_ssh_pass" => "vagrant",
          "ansible_ssh_user" => "vagrant"
        }
      }
    end
  end
  
  config.vm.define :server do |server|
    server.vm.box = "generic/fedora25"
    server.vm.hostname = "server"
    server.vbguest.auto_update = false
    server.vm.network "private_network", ip: "172.25.0.11", auto_config: false
    server.vm.provision :shell, run: "always", inline: "(nmcli device connect '#{devname}' &) && sleep 10 && nmcli con modify '#{conname}' ipv4.addresses 172.25.0.11/24 ipv4.dns 172.25.0.254 ipv4.method manual && nmcli con up '#{conname}'"
    server.vm.provision :shell, path: "provisioning/server-provision"
    server.vm.provision "file", source: "configs/client.conf", destination: "/home/vagrant/client.conf"
    server.vm.provision "file", source: "configs/auth.cfg", destination: "/home/vagrant/auth.cfg"
    server.vm.provision "file", source: "easy-rsa/easyrsa3/pki/ca.crt", destination: "/home/vagrant/ca.crt"
    server.vm.provision "file", source: "easy-rsa/easyrsa3/pki/private/client.key", destination: "/home/vagrant/client.key"
    server.vm.provision "file", source: "easy-rsa/easyrsa3/pki/issued/client.crt", destination: "/home/vagrant/client.crt"
    server.vm.provision :shell, path: "provisioning/ovpn-provision"
    server.vm.provider "virtualbox" do |vbox, override|
      vbox.cpus = 1
      vbox.memory = server_memory
      if !File.exist?(vbox_vm_path + 'rhel_server_2.vdi')
        vbox.customize ['createhd', '--filename', vbox_vm_path + 'rhel_server_2.vdi', '--variant', 'Fixed', '--size', extra_disk_size * 1024]
      end
      vbox.customize ['storageattach', :id,  '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', vbox_vm_path + 'rhel_server_2.vdi']
    end
  end

  
  config.vm.define :webserver do |webserver|
    webserver.vm.box = "generic/fedora25"
    webserver.vm.hostname = "server"
    webserver.vbguest.auto_update = false
    webserver.vm.network "private_network", ip: "172.16.0.22", auto_config: false
    webserver.vm.provision :shell, run: "always", inline: "(nmcli device connect '#{devname}' &) && sleep 10 && nmcli con modify '#{conname}' ipv4.addresses 172.16.0.22/24 ipv4.dns 172.16.0.254 ipv4.method manual && nmcli con up '#{conname}'"
    webserver.vm.provision :shell, path: "provisioning/web-server-provision"
    webserver.vm.provider "virtualbox" do |vbox, override|
      vbox.cpus = 1
      vbox.memory = server_memory
      if !File.exist?(vbox_vm_path + 'rhel_web-server_2.vdi')
        vbox.customize ['createhd', '--filename', vbox_vm_path + 'rhel_web-server_2.vdi', '--variant', 'Fixed', '--size', extra_disk_size * 1024]
      end
      vbox.customize ['storageattach', :id,  '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', vbox_vm_path + 'rhel_web-server_2.vdi']
    end
  end
  
  
  config.vm.define :client do |client|
    client.vm.box = "opentable/win-2012r2-standard-amd64-nocm"
    client.vbguest.auto_update = true
    client.vm.hostname = "client"
    # do NOT download the iso file from a webserver
    client.vbguest.no_remote = true
    client.vm.network "private_network", ip: "172.16.0.21"
    client.vm.provision "shell", path: "provisioning/provision.ps1", privileged: true
  end

end


