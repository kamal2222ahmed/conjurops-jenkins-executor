jenkins_home = node['jenkins']['master']['home']

directory "#{jenkins_home}/.ssh" do
  owner 'jenkins'
  group 'jenkins'
  mode '0700'
end

file "#{jenkins_home}/.ssh/id_rsa" do
  content conjur_secret 'jenkins/private-key'
  user 'jenkins'
  mode '0600'
  sensitive true
end

cookbook_file "#{jenkins_home}/.ssh/known_hosts" do
  source 'known_hosts'
  owner 'jenkins'
  group 'jenkins'
  mode '0600'
  cookbook 'conjurops-jenkins'
end

file "#{jenkins_home}/.ssh/authorized_keys" do
  action :create
  owner 'jenkins'
  group 'jenkins'
  mode '0600'
  content conjur_pubkeys('sys_jenkins')
  sensitive true
end
