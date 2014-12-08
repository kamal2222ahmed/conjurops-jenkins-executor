# Sets up the conjur identity file

file '/etc/conjur.identity' do
  content File.read('/vagrant/.netrc')
  mode 0600
  only_if { File.exists?('/vagrant/.netrc') }
end

file '/var/lib/jenkins/.netrc' do
  content File.read '/etc/conjur.identity'
  user 'jenkins'
  mode 0600
  only_if { File.exists?("/etc/conjur.identity") }
end
