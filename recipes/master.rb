include_recipe 'apt'
include_recipe 'jenkins::master'

include_recipe 'conjurops-jenkins::authentication'
include_recipe 'conjurops-jenkins::conjur'
include_recipe 'conjurops-jenkins::ssh'

package 'curl'
package 'vim'
