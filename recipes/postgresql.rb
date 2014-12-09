# Note: Database recipes don't work with Chef via Omnibus installer
# http://stackoverflow.com/questions/13054676/pg-gem-fails-to-install-on-omnibus-chef-installation
require 'etc'

 # hack needed on docker for postgres permissions https://github.com/nimiq/docker-postgresql93/pull/4
# execute "fix permissions for postgres" do
#   command <<-EOH
# mkdir /etc/ssl/private-copy;
# mv /etc/ssl/private/* /etc/ssl/private-copy/;
# rm -r /etc/ssl/private;
# mv /etc/ssl/private-copy /etc/ssl/private;
# chmod -R 0700 /etc/ssl/private;
# chown -R postgres /etc/ssl/private
#   EOH
#   only_if { File.exists?('/etc/ssl/private') && Etc.getpwuid(File.stat('/etc/ssl/private').uid).name != 'postgres' }
# end

include_recipe 'postgresql'
include_recipe 'postgresql::server'
include_recipe 'postgresql::contrib'

file '/etc/postgresql.password' do
  content node['postgresql']['password']['postgres']
end

bash "create database user 'jenkins'" do
  user 'postgres'

  code '' "
echo select 1 from pg_user where usename = \"'jenkins'\" | psql -qtA | grep -q 1 || createuser -s jenkins
  " ''
end

%w(authn authz core directory host_factory).each do |db|
  bash "Create database #{db}" do
    user 'postgres'
    code '' "
echo select 1 from pg_database where datname = \"'#{db}_test'\" | psql -qtA | grep -q 1 || createdb #{db}_test -O jenkins
    " ''
  end
end
