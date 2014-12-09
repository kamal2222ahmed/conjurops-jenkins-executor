# Sets up the conjur identity file

%w{/vagrant/.netrc /home/kitchen/project/.netrc}.each do |path|
  remote_file '/etc/conjur.identity' do
    source "file://#{path}"
    mode 0600

    only_if { File.exists?(path) }
  end
end

remote_file "#{node['jenkins']['master']['home']}/.netrc" do
  source 'file:///etc/conjur.identity'
  user 'jenkins'
  mode 0600
end
