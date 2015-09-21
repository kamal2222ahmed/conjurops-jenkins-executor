apt_repository "docker" do
  uri "https://apt.dockerproject.org/repo"
  distribution "ubuntu-trusty"
  components ["main"]
  keyserver "hkp://p80.pool.sks-keyservers.net:80"
  key "58118E89F3A912897C070ADBF76221572C52609D"
end

package "docker-engine"

service "docker" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

group 'docker' do
  append true
  members [node['user']['username']]
  action :modify
end

cookbook_file "/etc/default/docker" do
  source "docker"
  mode "0644"
  notifies :restart, "service[docker]", :delayed
end
