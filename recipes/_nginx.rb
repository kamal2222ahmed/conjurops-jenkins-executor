package "nginx-extras"

service "nginx" do
  action [:enable, :start]
end
