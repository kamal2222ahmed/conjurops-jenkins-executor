require 'spec_helper'

describe 'conjurops-jenkins-slave::_conjur' do
  it 'installs the conjur CLI' do
    expect(command('/opt/conjur/bin/conjur help').stdout).to match /COMMANDS/
  end

  it 'places the Chef role to bootstrap host-factory' do
    role = '/var/chef/roles/host-identity.json'

    expect(file(role)).to be_file
    expect(file(role).content).to match /"account": "conjurops"/
    expect(file(role).content).to match /ec2\/%%HOST_ID%%/
    expect(file(role).content).to match /%%HOST_TOKEN%%/
  end
end
