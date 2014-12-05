file "/var/lib/jenkins/.ssh/id_rsa" do
  content conjur_secret 'jenkins/private-key'
  user 'jenkins'
  mode 0600
end
