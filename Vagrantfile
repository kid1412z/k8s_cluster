# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  ##### Node1 #####
  config.vm.define "node1" do |node|
    node.vm.box = "centos/7"
    node.vm.hostname = "node1"
    node.vm.network "private_network", ip: "10.0.0.101"
    node.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", auto_config: true
    config.vm.box_check_update = false
    config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
      # Customize the amount of memory on the VM:
      vb.memory = 2048
      vb.cpus = 2
      # time sync
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end
    config.vm.provision "shell", inline: <<-SHELL
      sh /vagrant/config_tools.sh
      sh /vagrant/config_master.sh
    SHELL
  end

  ##### Node2 #####
  config.vm.define "node2" do |node|
    node.vm.box = "centos/7"
    node.vm.hostname = "node2"
    node.vm.network "private_network", ip: "10.0.0.102"
    node.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", auto_config: true
    config.vm.box_check_update = false
    config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
      # Customize the amount of memory on the VM:
      vb.memory = 2048
      vb.cpus = 2
      # time sync
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end
    config.vm.provision "shell", inline: <<-SHELL
    sh /vagrant/config_tools.sh
      sh /vagrant/config_nodes.sh 2
    SHELL
  end

  ##### Node3 #####
  config.vm.define "node3" do |node|
    node.vm.box = "centos/7"
    node.vm.hostname = "node3"
    node.vm.network "private_network", ip: "10.0.0.103"
    node.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", auto_config: true
    config.vm.box_check_update = false
    config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
      # Customize the amount of memory on the VM:
      vb.memory = 2048
      vb.cpus = 2
      # time sync
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end
    config.vm.provision "shell", inline: <<-SHELL
      sh /vagrant/config_tools.sh
      sh /vagrant/config_nodes.sh 3
    SHELL
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
