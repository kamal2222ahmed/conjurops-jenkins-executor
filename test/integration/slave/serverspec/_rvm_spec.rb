require 'spec_helper'

describe 'rvm' do
  it 'installs RVM' do
    expect(command('/var/lib/jenkins/.rvm/bin/rvm version').stdout).to match /^rvm 1\./
  end
end
