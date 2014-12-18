file '/opt/conjur.pem' do
  content node['conjur']['configuration']['ssl_certificate']
  sensitive true
end

template '/etc/conjur.conf' do
  source 'conjur.conf.erb'
  variables(
    account: node['conjur']['configuration']['account'],
    appliance_url: node['conjur']['configuration']['appliance_url'],
    cert_file: '/opt/conjur.pem'
  )
  sensitive true
end

package 'build-essential'
package 'ruby-dev'

gem_package 'conjur-cli' do
  action :upgrade
end

execute 'fix conjur permissions to allow non-root to run the CLI' do
  command 'chmod -R 755 /var/lib/gems/1.9.1/gems/conjur-*'
end

directory '/var/chef/roles' do
  recursive true
end

template '/var/chef/roles/host-identity.json' do
  source "host-identity.erb"
  variables({
    appliance_url: node['conjur']['configuration']['appliance_url'],
    account: node['conjur']['configuration']['account']
  })
end

cookbook_file '/opt/conjur-bootstrap.sh' do
  source 'conjur-bootstrap.sh'
  mode '0755'
end

