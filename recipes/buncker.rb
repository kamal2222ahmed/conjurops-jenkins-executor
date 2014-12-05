git "/var/lib/jenkins/buncker" do
  repository "git://github.com/conjurinc/buncker.git"
  user 'jenkins'
end

bash "make" do
  cwd '/var/lib/jenkins/buncker'
end

file "/etc/sudoers.d/jenkins-buncker" do
  content <<-SUDOERS
jenkins ALL=(ALL) NOPASSWD: /var/lib/jenkins/buncker/buncker.sh
  SUDOERS
end

