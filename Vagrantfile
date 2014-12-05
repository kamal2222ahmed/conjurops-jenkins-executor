%w(vagrant-omnibus).each do |gem|
  begin
    require gem
  rescue LoadError => e
    warn "Required gem not found: #{e}"
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
  
  config.ssh.forward_agent = true
    
  config.omnibus.chef_version = 'latest'

  config.vm.provider :virtualbox do |vbox, override|
    override.vm.network "forwarded_port", guest: 8080, host: 9080
    override.vm.network "forwarded_port", guest: 80, host: 9081
    override.vm.network "forwarded_port", guest: 443, host: 9443
    
    config.vm.provision "shell", inline: "cp /vagrant/.netrc /root/.netrc && chmod 0600 /root/.netrc"
    config.vm.provision "shell", inline: "cp /vagrant/.netrc /var/lib/jenkins/.netrc && chown jenkins /var/lib/jenkins/.netrc && chmod 0600 /var/lib/jenkins/.netrc"
  end

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.add_recipe 'conjurops-jenkins'
  end
end
