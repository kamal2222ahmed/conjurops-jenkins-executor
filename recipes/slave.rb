include_recipe "conjurops-jenkins::default"
include_recipe "conjurops-jenkins::software"

include_recipe "jenkins::slave"

include_recipe "conjurops-jenkins::jenkins"
