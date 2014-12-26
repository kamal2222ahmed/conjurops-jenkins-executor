docker_datadir = node['docker']['datadir']

%W(#{docker_datadir} #{docker_datadir}/tmp).each do |dir|
  directory dir do
    owner 'jenkins'
    group 'jenkins'
  end
end

remote_file '/opt/install_docker.sh' do
  mode '0755'
  source 'https://get.docker.com/'
  sensitive true  # not really sensitive, but don't need this in the chef log

  not_if { ::File.exist?('/opt/install_docker.sh')}
end

bash 'install docker' do
  cwd '/opt'
  code './install_docker.sh'

  not_if 'which docker'
end

service 'docker' do
  supports :status => true, :restart => true
  action :nothing
end

template '/etc/default/docker' do
  source 'docker_default.erb'
  variables(
    docker_datadir: docker_datadir
  )
  notifies :restart, 'service[docker]'
end

group 'docker' do
  append true
  members ['jenkins']
  action :modify
end
