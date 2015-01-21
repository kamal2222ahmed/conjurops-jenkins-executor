remote_file '/tmp/chefdk.deb' do
  source 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.3.5-1_amd64.deb'
  checksum 'a81c3dfad698fbb19a6c8e3dd65f04a15fd58a811d99db9c47e5a93e368f341d'
end

dpkg_package 'chefdk' do
  source '/tmp/chefdk.deb'
  action :install
end

execute 'install the kitchen-docker driver into ChefDK' do
  command 'chef gem install kitchen-docker --no-user-install'

  not_if 'chef gem list | grep kitchen-docker'
end
