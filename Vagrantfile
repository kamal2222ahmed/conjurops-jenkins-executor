%w(vagrant-omnibus).each do |gem|
  begin
    require gem
  rescue LoadError => e
    warn "Required gem not found: #{e}"
  end
end

boxes = [
  # Clean box, Ubuntu 14.04LTS - for experimentation
  {
    :name => :clean,
    :primary => false,
    :autostart => false,
    :memory => 2048,
    :recipes => []
  },
  # Jenkins slave box
  {
    :name => :slave,
    :primary => true,
    :autostart => true,
    :roles => ['builder'],
    :recipes => [
      'conjurops-jenkins-slave::default'
    ],
    :tags => {'conjur/app' => 'conjurops-jenkins-slave'}
  },
  {
    :name => :release_slave,
    :primary => false,
    :autostart => false,
    :roles => ['publisher'],
    :recipes => [
      'conjurops-jenkins-slave::release_slave'
    ],
    :tags => {'conjur/app' => 'conjurops-release-slave'}
  }  
]

Vagrant.configure("2") do |baseconfig|
  boxes.each do |opts|
    baseconfig.vm.define opts[:name], primary: opts[:primary], autostart: opts[:autostart] do |config|
      
      config.vm.synced_folder ".", "/vagrant", disabled: true
      
      config.vm.box = 'phusion/ubuntu-14.04-amd64'
      config.vm.network 'private_network', :type => 'dhcp'
      
      config.ssh.forward_agent = true

      config.vm.provider :virtualbox do |vbox, override|
        vbox.memory = opts[:memory] || 3072
        override.vm.synced_folder ".", "/vagrant"
        override.vm.synced_folder ENV['HOME'], ENV['HOME']
      end

      config.vm.provider :aws do |aws, override|
        override.vm.box_url="https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
        
        aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
        aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
        
        aws.ami = ENV['AWS_BASE_AMI']
        aws.instance_type="m3.medium"
        aws.tags = {'git_hash' => ENV['GIT_HASH'], 'git_tag' => ENV['GIT_TAG']}.merge(opts[:tags] || {})

        aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
        override.ssh.private_key_path = ENV['SSH_PRIVATE_KEY_PATH']
        override.ssh.username = 'ubuntu'
      end

      config.vm.provision :chef_solo do |chef|
        chef.roles_path = "roles"
        
        #chef.environment = 'development'
        #chef.environments_path = 'environments'
        
        Array(opts[:roles]).each { |r| chef.add_role(r) }
        opts[:recipes].each do |recipe|
          chef.add_recipe recipe
        end
      end

      config.vm.provision :shell, inline: <<-eos
        sudo apt-get purge -y chef
        sudo rm -rf /opt/chef
        sudo dpkg-reconfigure chefdk
      eos
      
    end
  end
end
