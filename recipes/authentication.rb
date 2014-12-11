# Required for Unix authentication
group 'shadow' do
  append true
  members ['jenkins']
  action :modify
end

service 'ssh' do
  action [:enable, :restart]
end
