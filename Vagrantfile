# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "chef/debian-7.4"
    config.vm.network "forwarded_port", guest: 80, host: 5000
    config.vm.network "private_network", ip: "192.168.33.33"
    config.ssh.forward_agent = true
    nfs_setting= RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
    config.vm.synced_folder ".", "/vagrant", id: "symbb-vagrant-root", type: "nfs", nfs_udp: false, :nfs => nfs_setting
    config.vm.provision "shell", path: "init.sh"
    config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = 'puppet/modules'
        puppet.manifest_file  = "init.pp"
        # puppet.options = "--verbose --debug"
    end
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["modifyvm", :id, "--cpus", "1"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
end
