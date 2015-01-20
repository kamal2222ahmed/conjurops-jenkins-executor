apt_repository "ubuntu-lxc" do
  uri "http://ppa.launchpad.net/ubuntu-lxc/stable/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "7635B973"
end

package "lxc"

if not node["virtualization"]["system"] == 'lxc'
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
