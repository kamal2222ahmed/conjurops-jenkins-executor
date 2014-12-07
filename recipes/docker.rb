include_recipe "docker"

# Required for Unix authentication
group "docker" do
  append true
  members [ "jenkins" ]
  action :modify
end
