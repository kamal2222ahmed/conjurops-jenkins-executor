
include_recipe "conjurops-jenkins::default"

include_recipe "jenkins::master"

node.jenkins.plugins.each do |plugin|
  if plugin.is_a?(Hash)
    jenkins_plugin plugin.keys[0] do
      version plugin[:version] if plugin[:version]
    end
  else
    jenkins_plugin plugin
  end
end

# Required for Unix authentication
group "shadow" do
  append true
  members [ "jenkins" ]
  action :modify
end


