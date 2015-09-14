username = node['user']['username']
user_home = node['user']['home']

if node["platform"] == "ubuntu" and node["platform_version"].to_f < 14.04
  apt_repository "ubuntu-lxc" do
    uri "http://ppa.launchpad.net/ubuntu-lxc/stable/ubuntu"
    distribution node['lsb']['codename']
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "7635B973"
  end
end

package "lxc"

# better to not try run modprobe inside LXC or Docker env
# it will not work in any way
case (node["virtualization"] || {})["system"]
when 'lxc', 'docker'
  # do nothing
else
  bash "modprobe ip6table_filter" do
    user "root"
    code "modprobe ip6table_filter"
    not_if "lsmod | grep ip6table_filter"
  end

  bash "install ip6table_filter in /etc/modules" do
    user "root"
    code "echo 'ip6table_filter' >> /etc/modules"
    not_if "grep '^ip6table_filter$' /etc/modules"
  end
end

bash "install knife-solo gem to chefdk" do
  user "root"
  code "sudo -i -u #{username} /opt/chefdk/embedded/bin/gem install knife-solo"
  not_if "find #{user_home}/.chefdk | grep knife-solo"
end

bash "add gem bin dir to PATH" do
  user "root"
  code "echo 'export PATH=$PATH:#{user_home}/.chefdk/gem/ruby/2.1.0/bin' >> #{user_home}/.profile"
  not_if "grep '#{user_home}/.chefdk/gem' #{user_home}/.profile"
end
