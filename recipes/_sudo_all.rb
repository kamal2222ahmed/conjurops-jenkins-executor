username = node['user']['username']
group_name = username

sudo username do
  user "%#{group_name}"
  nopasswd true
end
