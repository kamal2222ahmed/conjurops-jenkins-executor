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
end