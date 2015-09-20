bash 'install rvm' do
  user node['user']['username']
  code <<-CODE
cat "$0"
set -x
id
HOME=#{node['user']['home']}
echo $HOME
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
CODE
end
