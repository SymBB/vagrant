vagrant
=======

vagrant version with automatic installation of symbb sandbox

# How to use it

## What is Vagrant?

Read the official Site https://www.vagrantup.com/

## Steps

1) Install Vagrant
2) Clone the symbb/vagrant repo
3) go to the newly created repo directory
4) run "vagrant up"
5) link the url "symbb.local" and "dev.symbb.local" to the VM ( over you hosts file )
5.1) symbb.local:8080 is the production env. (port will skip varnish cache because currently not working)
5.2) dev.symbb.local:8080 is the dev. env. (port will skip varnish cache because currently not working)
6) enjoy! You have now a running VM with a installed Sandbox Version of Symbb

## vhost example

    192.168.33.33   symbb.local
	192.168.33.33	dev.symbb.local
	192.168.33.33	phpmyadmin.local

## Tip of the Day

The Symbb Vagrant repo has an "puppet" folder. Thats because we are using puppet to configure the VM.
If you run a real Server you can also extract the symbb module and run it manually on our server with puppet or implement it in our own puppet setup.
The symbb vhost need a default sf2 vhost configuration. This will be insert at the "nginx" modul. So if you only use the "symbb" modul please add this file manually.
The symbb vhost has a include for this file, so it will not work without.

