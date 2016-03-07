include_recipe 'apt'

package ['vim', 'dnsutils', 'apt-transport-https']

include_recipe 'conjurops-jenkins-slave::_user'
include_recipe 'conjurops-jenkins-slave::_sudo_release'
include_recipe 'conjurops-jenkins-slave::_conjur'
include_recipe 'conjurops-jenkins-slave::_summon'
include_recipe 'conjurops-jenkins-slave::_docker'
include_recipe 'conjurops-jenkins-slave::_chefdk'
include_recipe 'conjurops-jenkins-slave::_dnsmasq'
include_recipe 'conjurops-jenkins-slave::_nginx'
include_recipe 'conjurops-jenkins-slave::_docker_registry'

include_recipe 'conjurops-jenkins-slave::_github'
include_recipe 'conjurops-jenkins-slave::_pubbit'
include_recipe 'conjurops-jenkins-slave::_upgrades'
