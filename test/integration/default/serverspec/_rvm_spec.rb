require 'spec_helper'

describe 'rvm' do
  it 'installs RVM' do
    expect(command('sudo -i -u jenkins rvm version').stdout).to match /^rvm 1\./
  end
end
