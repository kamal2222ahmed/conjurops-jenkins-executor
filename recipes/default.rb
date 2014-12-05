if File.exists?('/vagrant/.netrc')
  netrc = File.read('/vagrant/.netrc')
  
  file '/etc/conjur.identity' do
    content netrc
    mode 0600
  end.run_action(:create)
end

include_recipe "conjur-host-identity"
include_recipe "apt"
include_recipe 'build-essential'

package "curl"
package "vim"
