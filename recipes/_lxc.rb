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
if not (node["virtualization"] || {})["system"] == 'lxc'
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

# This gives no any secure, wildcard in sudoers doesn't work securely
# So, what about password less sudo for jenkins user?

%w(lxc-attach lxc-destroy lxc-start-ephemeral lxc-autostart lxc-device lxc-stop lxc-cgroup lxc-execute lxc-top lxc-checkconfig lxc-freeze lxc-unfreeze lxc-checkpoint lxc-info lxc-unshare lxc-clone lxc-ls lxc-usernsexec lxc-config lxc-monitor lxc-wait lxc-console lxc-snapshot lxc-create lxc-start).each do |cmd|
  sudo cmd do
    user     "%sudo"
    runas    "root"
    nopasswd true
    commands ["/usr/bin/#{cmd} *"]
  end
end

sudo 'lxc--mkdir1' do
  user     "%sudo"
  runas    "root"
  nopasswd true
  commands ["/bin/mkdir /var/lib/lxc/*/rootfs/*"]
end

sudo 'lxc--mkdir2' do
  user     "%sudo"
  runas    "root"
  nopasswd true
  commands ["/bin/mkdir -p /var/lib/lxc/*/rootfs/*"]
end

sudo 'lxc--chmod1' do
  user     "%sudo"
  runas    "root"
  nopasswd true
  commands ["/bin/chmod -R 0440 /var/lib/lxc/*/rootfs/*"]
end

sudo 'lxc--chmod2' do
  user     "%sudo"
  runas    "root"
  nopasswd true
  commands ["/bin/chmod 0755 /var/lib/lxc/*/rootfs/*"]
end

sudo 'lxc--tee1' do
  user     "%sudo"
  runas    "root"
  nopasswd true
  commands ["/usr/bin/tee /var/lib/lxc/*/rootfs/*"]
end

sudo 'lxc--tee2' do
  user     "%sudo"
  runas    "root"
  nopasswd true
  commands ["/usr/bin/tee --append /var/lib/lxc/*/fstab"]
end
