include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'jenkins::master'

# chef_gem 'conjur-api'
# chef_gem 'conjur-cli'

include_recipe 'conjurops-jenkins::authentication'
include_recipe 'conjurops-jenkins::identity'
include_recipe 'conjurops-jenkins::ssh'
# include_recipe 'conjurops-jenkins::postgresql'
include_recipe 'conjurops-jenkins::docker'
include_recipe 'conjurops-jenkins::buncker'

package 'curl'
package 'vim'
