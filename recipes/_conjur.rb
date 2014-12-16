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
