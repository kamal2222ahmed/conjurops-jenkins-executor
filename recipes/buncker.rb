git '/opt/buncker' do
  repository 'git://github.com/conjurinc/buncker.git'
end

bash 'make' do
  cwd '/opt/buncker'
end
