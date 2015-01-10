package 'build-essential'
package 'ruby-dev'

include_recipe 'conjur-client'

directory '/var/chef/roles' do
  recursive true
end

template '/var/chef/roles/host-identity.json' do
  source "host-identity.erb"
  variables({
    appliance_url: node['conjur']['configuration']['appliance_url'],
    account: node['conjur']['configuration']['account'],
    ssl_certificate: node['conjur']['configuration']['ssl_certificate']
  })
end

cookbook_file '/opt/conjur-bootstrap.sh' do
  source 'conjur-bootstrap.sh'
  mode '0755'
end

# Use append so that the group members aren't clobbered, in case
# the conjur group is previously created with some other members.
group 'conjur' do
  append true
  members ['jenkins']
end
