execute "install aufs" do
  command "apt-get install -y linux-image-extra-#{node[:kernel][:release]} && modprobe aufs"
end

apt_repository "docker" do
  uri "https://get.docker.com/ubuntu"
  distribution "docker"
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "36A1D7869245C8950F966E92D8576A8BA88D21E9"
end

package "lxc-docker"

service "docker" do
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
