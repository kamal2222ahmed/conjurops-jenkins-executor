jenkins_home = node['jenkins']['home']

user 'jenkins' do
  action :create
  comment 'Jenkins user'
  home jenkins_home
  shell '/bin/bash'
  supports manage_home: true
end

group 'jenkins' do
  members ['jenkins']
end

service 'ssh'

# Required for Unix authentication
group 'shadow' do
  append true
  members ['jenkins']
  action :modify

  notifies :restart, 'service[ssh]'
end

directory "#{jenkins_home}/.ssh" do
  owner 'jenkins'
  group 'jenkins'
  mode '0700'
end

cookbook_file "#{jenkins_home}/.ssh/known_hosts" do
  source 'known_hosts'
  owner 'jenkins'
  group 'jenkins'
  mode '0600'
end
