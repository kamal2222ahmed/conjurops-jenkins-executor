file '/opt/conjur.pem' do
  content node['conjur']['configuration']['ssl_certificate']
end

template "/etc/conjur.conf" do
  source "conjur.conf.erb"
  variables(
    :account => node['conjur']['configuration']['account'],
    :appliance_url => node['conjur']['configuration']['appliance_url'],
    :cert_file => '/opt/conjur.pem'
  )
  sensitive true
end

# Sets up the conjur identity file
%w{/vagrant/.netrc /home/kitchen/project/.netrc}.each do |path|
  remote_file '/etc/conjur.identity' do
    source "file://#{path}"
    mode 0600
    sensitive true

    only_if { File.exists?(path) }
  end
end

remote_file "#{node['jenkins']['master']['home']}/.netrc" do
  source 'file:///etc/conjur.identity'
  user 'jenkins'
  mode 0600
  sensitive true
end
