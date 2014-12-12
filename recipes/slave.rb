include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'

package 'openjdk-6-jdk'

user 'jenkins' do
  action :create
  comment 'Jenkins user'
  home node['jenkins']['master']['home']
  shell '/bin/bash'
  supports manage_home: true
end

group 'jenkins' do
  members ['jenkins']
end

chef_gem 'conjur-api'
chef_gem 'conjur-cli'

include_recipe 'conjurops-jenkins::_vagrant'
include_recipe 'conjurops-jenkins::_rvm'
include_recipe 'conjurops-jenkins::_authentication'
include_recipe 'conjurops-jenkins::_conjur'
include_recipe 'conjurops-jenkins::_ssh'
