include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'rvm::system_install'
include_recipe 'vagrant'

rvm_ruby '1.9.3'
rvm_ruby '2.0.0'

user "jenkins" do
  action :create
  comment "Jenkins user"
  home node['jenkins']['master']['home']
  shell "/bin/bash"
  supports :manage_home => true
end

group "jenkins" do
  members ['jenkins']
end

chef_gem 'conjur-api'
chef_gem 'conjur-cli'

include_recipe 'conjurops-jenkins::authentication'
include_recipe 'conjurops-jenkins::conjur'
include_recipe 'conjurops-jenkins::ssh'
