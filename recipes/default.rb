#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

if File.exists?('/vagrant/.netrc')
  netrc = File.read('/vagrant/.netrc')
  
  file '/etc/conjur.identity' do
    content netrc
    mode 0600
  end.run_action(:create)
end

include_recipe "conjur-host-identity"

require 'conjur/authn'
conjur = Conjur::Authn.connect

include_recipe "apt"
include_recipe 'build-essential'

package "curl"
package "vim"
package "git"
package "docker.io"

include_recipe "jenkins::master"

directory "/var/lib/jenkins/.ssh" do
  user 'jenkins'
end

node.jenkins.plugins.each do |plugin|
  jenkins_plugin plugin
end

file "/var/lib/jenkins/.ssh/known_hosts" do
  content <<-KNOWN_HOSTS
|1|VTi9HyIBuPG2/EeW+nWWW+8eJP0=|zlkgFrGs4x97RgyUhTYiceE5Rh0= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|pzjXkLIu9egzJgOCJ8vXAXA4MMw=|/2Ib9CsuaHgO2iiw35KmcHXJxrs= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
  KNOWN_HOSTS
  user 'jenkins'
end

file '/var/lib/jenkins/.netrc' do
  content File.read '/etc/conjur.identity'
  user 'jenkins'
  mode 0600
end

file "/var/lib/jenkins/.ssh/id_rsa" do
  content conjur.variable('jenkins/private-key').value
  user 'jenkins'
  mode 0600
end

# RVM key trust
execute "gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3" do
  user 'jenkins'
  environment 'HOME' => '/var/lib/jenkins'
end
execute "curl -sSL https://get.rvm.io | bash -s stable" do
  user 'jenkins'
  environment 'HOME' => '/var/lib/jenkins'
  creates '/var/lib/jenkins/.rvm'
end

%w(ruby-1.9.3 ruby-2.0.0).each do |ruby|
  bash "rvm install #{ruby}" do
    user 'jenkins'
  end
  %w(bundler conjur-cli).each do |gem|
    bash "rvm #{ruby} do gem install #{gem}" do
      user 'jenkins'
    end
  end
end

include_recipe "nodejs"
