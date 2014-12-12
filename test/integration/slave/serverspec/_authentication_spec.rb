require 'spec_helper'

describe 'conjurops-jenkins::_authentication' do
  it 'places jenkins user in group "shadow"' do
    expect(user('jenkins')).to belong_to_group('shadow')
  end

  it 'enables the ssh service' do
    expect(service('ssh')).to be_enabled
  end
end