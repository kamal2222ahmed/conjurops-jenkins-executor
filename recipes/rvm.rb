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
