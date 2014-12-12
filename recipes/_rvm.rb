# Installs and configures RVM for Jenkins user

jenkins_home = node['jenkins']['master']['home']

# RVM key trust
execute 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3' do
  user 'jenkins'
  environment 'HOME' => jenkins_home
end

execute 'curl -sSL https://get.rvm.io | bash -s stable' do
  user 'jenkins'
  environment 'HOME' => jenkins_home
  creates "#{jenkins_home}/.rvm"
end

# Dependencies will fail to install because Jenkins doesn't have permission to install packages. We will do it manually
# (see below).
# http://stackoverflow.com/questions/16563115/how-to-install-rvm-system-requirements-without-giving-sudo-for-rvm-user
bash 'rvm autolibs fail' do
  code <<-EOH
source #{jenkins_home}/.rvm/scripts/rvm
rvm autolibs fail
  EOH
end

# Ruby requirements
packages = %w(
  gawk libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev
  sqlite3 libgdbm-dev libtool pkg-config libffi-dev libgecode36
)
packages.each do |pkg|
  package pkg
end

rubies = %w(ruby-1.9.3 ruby-2.0.0 ruby-2.1.0)
gems = %w(bundler conjur-cli)

rubies.each do |ruby|
  bash "rvm install #{ruby}" do
    code <<-EOH
source #{jenkins_home}/.rvm/scripts/rvm
rvm install #{ruby}
    EOH
    user 'jenkins'
    not_if "ls #{jenkins_home}/.rvm/rubies | grep #{ruby}"
  end

  gems.each do |mygem|
    bash "rvm #{ruby} do gem install #{mygem}" do
      code <<-EOH
source #{jenkins_home}/.rvm/scripts/rvm
rvm #{ruby} do gem install #{mygem}
    EOH
      user 'jenkins'

      not_if "ls #{jenkins_home}/.rvm/gems/#{ruby}*/gems | grep #{mygem}"
    end
  end
end
