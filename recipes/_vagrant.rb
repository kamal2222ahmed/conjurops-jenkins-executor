include_recipe 'vagrant'

jenkins_home = node['jenkins']['master']['home']

directory "#{jenkins_home}/.vagrant.d"

execute "chown the vagrant.d dir as jenkins" do
  command "chown -R jenkins:jenkins #{jenkins_home}/.vagrant.d"
end


plugins = [
  {name: 'vagrant-ami', version: '0.0.1'},
  {name: 'vagrant-aws', version: '0.5.0'},
  {name: 'vagrant-omnibus', version: '1.4.1'},
]

plugins.each do |plugin|
  execute "install vagrant plugin #{plugin[:name]}" do
    command "vagrant plugin install #{plugin[:name]} --plugin-version #{plugin[:version]}"
    environment 'HOME' => jenkins_home

    not_if "vagrant plugin list | grep #{plugin[:name]}"
  end
end
