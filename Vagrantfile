begin
  require 'vagrant-omnibus'
rescue LoadError => e
  warn "Required plugin not found:\n#{e}"
end

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  
  config.ssh.forward_agent = true
    
  config.omnibus.chef_version = 'latest'

  config.vm.provider :virtualbox do |vbox, override|
    override.vm.network "forwarded_port", guest: 8080, host: 9080
    override.vm.network "forwarded_port", guest: 80, host: 9081
    override.vm.network "forwarded_port", guest: 443, host: 9443
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'conjurops-jenkins'
  end
end
