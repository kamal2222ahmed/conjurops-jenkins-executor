include_recipe "jenkins::master"

include_recipe "conjurops-jenkins::authentication"
include_recipe "conjurops-jenkins::identity"
include_recipe "conjurops-jenkins::known_hosts"
include_recipe "conjurops-jenkins::plugins"
include_recipe "conjurops-jenkins::software"
