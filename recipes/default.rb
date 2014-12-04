#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

package "curl"
package "vim"
package "git"

include_recipe "jenkins::master"

file_name = "conjur_4.17.0-5_amd64.deb"
target_path = File.join(Chef::Config[:file_cache_path], file_name)

dpkg_package "conjur" do
  source target_path
  action :nothing
end

remote_file target_path do
  source "https://s3.amazonaws.com/conjur-releases/omnibus/conjur_4.17.0-5_amd64.deb"
  notifies :install, "dpkg_package[conjur]", :immediately
end

account = node.conjur.configuration.account
conjurrc = {
  "account" => account,
  "plugins" => node.conjur.configuration['plugins'].to_a,
  "appliance_url" => node.conjur.configuration.appliance_url,
  "cert_file" => "/etc/conjur-#{account}.pem"
}

file "/etc/conjur.conf" do
  content YAML.dump(conjurrc)
  mode "0644"
end

file "/etc/conjur-#{account}.pem" do
  content node.conjur.configuration.ssl_certificate
  mode "0644"
end
