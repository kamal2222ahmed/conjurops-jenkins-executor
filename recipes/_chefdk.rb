file_name = 'chefdk.deb'
target_path = File.join(Chef::Config[:file_cache_path], file_name)

remote_file target_path do
  source node['chefdk']['url']
end

dpkg_package 'chefdk' do
  source target_path
end

execute 'install the kitchen drivers into ChefDK' do
  command <<-EOH
  chef gem install kitchen-docker --no-user-install
  chef gem install kitchen-ec2 --no-user-install
  EOH

  not_if 'chef gem list | grep kitchen-docker'
end
