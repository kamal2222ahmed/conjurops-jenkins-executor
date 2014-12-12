require 'spec_helper'

describe 'conjurops-jenkins::_awscli' do
  it 'installs python and headers' do
    %w(python python-dev).each do |pkg|
      expect(package(pkg)).to be_installed
    end
  end

  it 'installs the awscli via pip' do
    expect(command('pip show awscli').stdout).to match /Version: 1.6.9/
    expect(command('aws --version').stdout).to match /1.6.9/
  end
end