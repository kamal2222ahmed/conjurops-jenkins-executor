include_recipe 'vagrant'

['vagrant-aws', 'vagrant-ami', 'vagrant-berkshelf'].each do |p|
  vagrant_plugin p do
    user 'jenkins'
  end
end


