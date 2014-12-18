require 'spec_helper'

describe 'conjurops-jenkins-slave::_conjur' do
  it 'places the conjur pem file' do
    expect(file('/opt/conjur.pem')).to be_file
  end

  it 'renders /etc/conjur.conf' do
    conf = '/etc/conjur.conf'

    expect(file(conf)).to be_file
    expect(file(conf).content).to match /account: conjurops/
  end

  it 'installs the conjur CLI' do
    expect(command('which conjur').stdout).to match /\/usr\/local\/bin\/conjur/
    expect(command('conjur --version').stdout).to match /conjur version/
  end

  it 'places the Chef role to bootstrap host-factory' do
    role = '/var/chef/roles/host-identity.json'

    expect(file(role)).to be_file
    expect(file(role).content).to match /"account": "conjurops"/
    expect(file(role).content).to match /ec2\/{{HOST_ID}}/
    expect(file(role).content).to match /{{HOST_TOKEN}}/
  end

  it 'places the conjur-bootstrap script' do
    bootstrap = '/opt/conjur-bootstrap.sh'

    expect(file(bootstrap)).to be_file
    expect(file(bootstrap)).to be_executable
  end
end