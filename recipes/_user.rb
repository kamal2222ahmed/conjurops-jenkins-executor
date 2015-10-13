username = node['user']['username']
user_home = node['user']['home']

user username do
  home user_home
  shell '/bin/bash'
  supports manage_home: true
end

group_name = username
group group_name do
  members [username]
end

directory "#{user_home}/.ssh" do
  owner username
  group group_name
  mode '0700'
end

cookbook_file "#{user_home}/.ssh/known_hosts" do
  source 'known_hosts'
  owner username
  group group_name
  mode '0600'
end

cookbook_file "#{user_home}/.bash_profile" do
  source 'bash_profile'
  owner username
  group group_name
end
