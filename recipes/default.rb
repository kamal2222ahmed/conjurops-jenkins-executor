include_recipe 'apt'

execute 'apt-get dist-upgrade' do
  env 'DEBIAN_FRONTEND' => 'noninteractive'
  command 'apt-get update && apt-get dist-upgrade -yqq'
end

package 'git'
package 'vim'

# for programm dig
package 'dnsutils'

# test kitchens docker image with ubuntu doesn't have this package
package "apt-transport-https"

include_recipe 'conjurops-jenkins-slave::_user'
include_recipe 'conjurops-jenkins-slave::_java'
include_recipe 'conjurops-jenkins-slave::_conjur'
include_recipe 'conjurops-jenkins-slave::_summon'
include_recipe 'conjurops-jenkins-slave::_docker'
include_recipe 'conjurops-jenkins-slave::_chefdk'
include_recipe 'conjurops-jenkins-slave::_lxc'
include_recipe 'conjurops-jenkins-slave::_dnsmasq'
include_recipe 'conjurops-jenkins-slave::_nginx'
include_recipe 'conjurops-jenkins-slave::_docker_registry'

include_recipe 'packer'
include_recipe 'conjurops-jenkins-slave::_vagrant'

