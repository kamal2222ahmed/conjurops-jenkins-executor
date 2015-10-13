username = node['user']['username']
group_name = username

sudo username do
  user "%#{group_name}"
  name username
  commands ['/opt/pubbit/bin/promote_to_docker']
end
