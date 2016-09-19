include_recipe 'vagrant'

['vagrant-aws', 'vagrant-ami', 'vagrant-berkshelf'].each do |p|
  vagrant_plugin p do
    user 'jenkins'

    # Both sets of quotes are required to get the version passed
    # properly to 'vagrant plugin install'
    version "'~>4'" if p == 'vagrant-berkshelf'

  end
end


