git node['pubbit']['home']  do
  repository node['pubbit']['repo']
  revision 'master'
  action :sync
end

ruby_block 'clean up' do
  action :create
  block do
    require 'fileutils'
    Dir.glob("#{node['pubbit']['home']}/*").each do |p|
      next if File.basename(p) == node['pubbit']['script_dir']
      FileUtils.rm_r(p)
    end
  end
end
