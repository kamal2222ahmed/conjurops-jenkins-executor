require 'spec_helper'

describe 'conjurops-jenkins-slave::_dnsmasq' do
  # for some reason dnsmasq doesn't on docker containers (using kitchen's driver for docker)
  # it 'dig can find A record for registry name' do
  #   expect(command('dig registry').stdout).to match /^registry.*127\.0\.0\.1/
  # end

  # just casual check
  it 'check dnsmasq conf' do
    expect(file('/etc/dnsmasq.conf').content).to match /registry/
  end
end
