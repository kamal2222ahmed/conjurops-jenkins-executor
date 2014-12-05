include_recipe "conjurops-jenkins::default"


package "git"
include_recipe "docker"

directory "/var/lib/jenkins/.ssh" do
  user 'jenkins'
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
  content conjur_secret 'jenkins/private-key'
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

# http://stackoverflow.com/questions/16563115/how-to-install-rvm-system-requirements-without-giving-sudo-for-rvm-user
# Dependencies will fail to install anyway because Jenkins doesn't have sudo access
bash "rvm autolibs fail" do
  user 'jenkins'
end
  
# Ruby requirements
%w(libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libgdbm-dev libtool pkg-config libffi-dev).each do |pkg|
  package pkg
end

%w(ruby-1.9.3 ruby-2.0.0).each do |ruby|
  bash "rvm install #{ruby}" do
    user 'jenkins'
    environment 'HOME' => '/var/lib/jenkins'
  end
  %w(bundler conjur-cli).each do |gem|
    bash "rvm #{ruby} do gem install #{gem}" do
      user 'jenkins'
      environment 'HOME' => '/var/lib/jenkins'
    end
  end
end

include_recipe "nodejs"

git "/var/lib/jenkins/buncker" do
  repository "git://github.com/conjurinc/buncker.git"
  user 'jenkins'
end

bash "make" do
  cwd '/var/lib/jenkins/buncker'
end

file "/etc/sudoers.d/jenkins" do
  content <<-SUDOERS
jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker
jenkins ALL=(ALL) NOPASSWD: /var/lib/jenkins/buncker/buncker.sh
  SUDOERS
end
