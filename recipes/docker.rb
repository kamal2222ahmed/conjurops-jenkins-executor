include_recipe "docker"

file "/etc/sudoers.d/jenkins-docker" do
  content <<-SUDOERS
jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker
  SUDOERS
end
