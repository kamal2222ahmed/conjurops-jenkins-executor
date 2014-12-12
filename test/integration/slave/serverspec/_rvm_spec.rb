require 'spec_helper'

rvm_binary = '/mnt/jenkins/.rvm/bin/rvm'

describe 'conjurops-jenkins::_rvm' do
  it 'installs rvm into jenkins home dir' do
    expect(file(rvm_binary)).to be_executable
    expect(file(rvm_binary)).to be_owned_by('jenkins')
  end

  it 'installs rubies 1.9.3, 2.0.0 and 2.1.0' do
    expect(command("#{rvm_binary} list").stdout).to match /1.9.3/
    expect(command("#{rvm_binary} list").stdout).to match /2.0.0/
    expect(command("#{rvm_binary} list").stdout).to match /2.1.0/
  end
end