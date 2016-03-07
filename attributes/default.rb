default['apt']['compile_time_update'] = true

default['user']['username'] = 'jenkins'
default['user']['home'] = File.join('', 'var', 'lib', node['user']['username'])

default['nginx']['sites-enabled'] = '/etc/nginx/sites-enabled/'
default['nginx']['sites-available'] = '/etc/nginx/sites-available/'
default['nginx']['conf.d'] = '/etc/nginx/conf.d'

default['docker-registry']['local-hostname-ci'] = 'registry'
default['docker-registry']['home'] = '/opt/nginx-registry/conjur'
default['docker-registry']['nginx-lua.git'] = 'https://github.com/conjurinc/nginx-lua.git'
default['docker-registry']['nginx-lua.git-revision'] = '775d4b7f7b0655a8955c626a0dbb47fa47b0d5b8'
default['docker-registry']['appliance-url'] = 'https://conjur-master.itp.conjur.net/api/authn'
default['docker-registry']['netrc-path'] = '/etc/conjur.identity'
default['docker-registry']['registry-url-ci'] = 'https://docker-registry.itci.conjur.net'

default['pubbit']['repo'] = 'https://github.com/conjurinc/pubbit.git'
default['pubbit']['home'] = '/opt/pubbit'
