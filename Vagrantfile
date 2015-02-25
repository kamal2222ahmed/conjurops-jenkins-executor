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
    :recipes => [
      'conjurops-jenkins-slave::default'
    ]
  }
]

Vagrant.configure("2") do |baseconfig|
  boxes.each do |opts|
    baseconfig.vm.define opts[:name], primary: opts[:primary], autostart: opts[:autostart] do |config|
      config.vm.box = 'ubuntu/trusty64'
      config.ssh.forward_agent = true

      config.vm.provider :virtualbox do |vbox, override|
        vbox.memory = opts[:memory] || 1024
      end

      config.vm.provision :chef_solo do |chef|
        opts[:recipes].each do |recipe|
          chef.add_recipe recipe
        end
      end
    end
  end
end
