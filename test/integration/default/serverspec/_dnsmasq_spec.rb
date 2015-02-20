require 'spec_helper'

describe 'conjurops-jenkins-slave::_dnsmasq' do
  it 'dig can find A record for registry name' do
    expect(command('dig registry').stdout).to match /^registry.*127\.0\.0\.1/
  end
end
