include_recipe 'apt'
include_recipe 'git'

package 'openjdk-6-jdk'

include_recipe 'conjurops-jenkins-slave::_user'
include_recipe 'conjurops-jenkins-slave::_conjur'
include_recipe 'conjurops-jenkins-slave::_docker'
