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
    # Setting up Jenkins is pretty memory-intensive
    vbox.memory = 1024
    override.vm.network "forwarded_port", guest: 8080, host: 9080
    override.vm.network "forwarded_port", guest: 80, host: 9081
    override.vm.network "forwarded_port", guest: 443, host: 9443
  end
  
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
  end
  
  config.vm.define "master" do |master|
    master.vm.provision :chef_solo do |chef|
      chef.add_recipe 'conjurops-jenkins::master'
    end
  end
 
  config.vm.define "slave" do |slave|
    slave.vm.provision :chef_solo do |chef|
      chef.add_recipe 'conjurops-jenkins::slave'
    end
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    override.ssh.private_key_path = ENV['SSH_PRIVATE_KEY_PATH']
  end
end
