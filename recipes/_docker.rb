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

# Required for Unix authentication
group 'docker' do
  append true
  members ['jenkins']
  action :modify
end
