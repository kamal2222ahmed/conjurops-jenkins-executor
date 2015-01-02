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
    vbox.memory = 1024
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'conjurops-jenkins-slave::default'
  end
end
