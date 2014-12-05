if File.exists?('/vagrant/.netrc')
  netrc = File.read('/vagrant/.netrc')
  
  file '/etc/conjur.identity' do
    content netrc
    mode 0600
  end.run_action(:create)
end

include_recipe "conjur-host-identity"

file '/var/lib/jenkins/.netrc' do
  content File.read '/etc/conjur.identity'
  user 'jenkins'
  mode 0600
end

