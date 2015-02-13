include_recipe 'apt'

package 'git'
package 'openjdk-6-jdk'

include_recipe 'conjurops-jenkins-slave::_user'
include_recipe 'conjurops-jenkins-slave::_conjur'
include_recipe 'conjurops-jenkins-slave::_docker'
include_recipe 'conjurops-jenkins-slave::_chefdk'
include_recipe 'conjurops-jenkins-slave::_lxc'

include_recipe 'packer'
