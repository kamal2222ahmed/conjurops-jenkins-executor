package "dnsmasq"

cookbook_file "/etc/dnsmasq.conf" do
  source "dnsmasq.conf"
end

service "dnsmasq" do
  action [:enable , :restart]
end
