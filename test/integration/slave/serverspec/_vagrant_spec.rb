require 'spec_helper'

describe 'conjurops-jenkins::_vagrant' do
  it 'installs vagrant v1.7.0 and plugins' do
    plugin_list_cmd = 'sudo su - jenkins -c "vagrant plugin list"'

    expect(command('vagrant version').stdout).to match /Installed Version: 1.7.0/
    expect(command(plugin_list_cmd).stdout).to match /vagrant-ami/
    expect(command(plugin_list_cmd).stdout).to match /vagrant-aws/
    expect(command(plugin_list_cmd).stdout).to match /vagrant-omnibus/
  end
end