execute 'install the kitchen-docker driver' do
  command 'chef gem install kitchen-docker --no-user-install'

  not_if 'chef gem list | grep kitchen-docker'
end
