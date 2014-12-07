# Note: Database recipes don't work with Chef via Omnibus installer
# http://stackoverflow.com/questions/13054676/pg-gem-fails-to-install-on-omnibus-chef-installation

include_recipe "postgresql"
include_recipe "postgresql::server"
include_recipe "postgresql::contrib"

file "/etc/postgresql.password" do
  content node['postgresql']['password']['postgres']
end

bash "create database user 'jenkins'" do
  user 'postgres'

  code """
echo select 1 from pg_user where usename = \"'jenkins'\" | psql -qtA | grep -q 1 || createuser -s jenkins
  """
end

%w(authn authz core directory host_factory).each do |db|
  bash "Create database #{db}" do
    user 'postgres'
    code """
echo select 1 from pg_database where datname = \"'#{db}_test'\" | psql -qtA | grep -q 1 || createdb #{db}_test -O jenkins
    """
  end
end
