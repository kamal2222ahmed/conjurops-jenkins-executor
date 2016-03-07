include_recipe 'apt'

package 'ntp'
package 'git'
package 'nano'
package 'vim'

# for programm dig
package 'dnsutils'

# test kitchens docker image with ubuntu doesn't have this package
package "apt-transport-https"

include_recipe 'conjurops-jenkins-slave::_user'
include_recipe 'conjurops-jenkins-slave::_sudo_all'
include_recipe 'conjurops-jenkins-slave::_java'
include_recipe 'conjurops-jenkins-slave::_conjur'
include_recipe 'conjurops-jenkins-slave::_summon'
include_recipe 'conjurops-jenkins-slave::_docker'
include_recipe 'conjurops-jenkins-slave::_chefdk'
include_recipe 'conjurops-jenkins-slave::_dnsmasq'
include_recipe 'conjurops-jenkins-slave::_nginx'
include_recipe 'conjurops-jenkins-slave::_docker_registry'
include_recipe 'conjurops-jenkins-slave::_rvm'
include_recipe 'conjurops-jenkins-slave::_debify'

include_recipe 'packer'
include_recipe 'conjurops-jenkins-slave::_vagrant'

# Installs security patches
# http://packages.ubuntu.com/trusty-updates/unattended-upgrades
package 'unattended-upgrades'
execute 'unattended-upgrade -v'
