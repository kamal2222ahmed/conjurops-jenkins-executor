require 'spec_helper'

describe 'conjurops-jenkins-slave::_chefdk' do
  it 'installs the ChefDK' do
    expect(command('chef --version').stdout).to match /Chef Development Kit Version: 0.3.5/
  end

  it 'installs the kitchen-docker driver' do
    expect(command('chef gem list | grep kitchen-docker').stdout).to match /kitchen-docker/
  end
end
