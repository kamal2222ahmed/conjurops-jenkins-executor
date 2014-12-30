remote_file '/opt/install_docker.sh' do
  mode '0755'
  source 'https://get.docker.com/'
  sensitive true  # not really sensitive, but don't need this in the chef log
  action :create_if_missing
end

bash 'install docker' do
  cwd '/opt'
  code './install_docker.sh'

  creates '/usr/bin/docker'
end

group 'docker' do
  append true
  members ['jenkins']
  action :modify
end
