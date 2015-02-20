sites_enabled = node['nginx']['sites-enabled']
sites_available = node['nginx']['sites-available']

link "#{sites_enabled}/registry.conf" do
  to "#{sites_available}/registry.conf"
  notifies :restart, "service[nginx]", :delayed
end

template "#{sites_available}/registry.conf" do
  source "registry.conf"
  mode "0644"
  variables({
    :local_hostname => node['docker-registry']['local-hostname-ci'],
    :appliance_url => node['docker-registry']['appliance-url'],
    :registry_url_ci => node['docker-registry']['registry-url-ci']
  })
  notifies :create, "link[#{sites_enabled}/registry.conf]", :immediately
  notifies :restart, "service[nginx]", :delayed
end

conf_d = node['nginx']['conf.d']

template "#{conf_d}/lua.conf" do
  source "lua.conf"
  mode "0644"
  variables({
    :home => node['docker-registry']['home'],
    :appliance_url => node['docker-registry']['appliance-url'],
    :netrc_path => node['docker-registry']['netrc-path']
  })
  notifies :restart, "service[nginx]", :delayed
end

registry_home = node['docker-registry']['home']

directory registry_home do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

git registry_home do
  repository node['docker-registry']['nginx-lua.git']
  revision node['docker-registry']['nginx-lua.git-revision']
  action :sync
end
