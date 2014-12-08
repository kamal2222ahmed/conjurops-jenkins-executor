require 'spec_helper'

describe 'conjurops-jenkins::master' do
  it 'should install and start jenkins' do
    expect(package('jenkins')).to be_installed
    expect(service('jenkins')).to be_enabled
    expect(service('jenkins')).to be_running
    expect(port(8080)).to be_listening
  end

  it 'should create group "shadow" and add jenkins user to it' do
    expect(group('shadow')).to exist
    expect(user('jenkins')).to exist
    expect(user('jenkins')).to belong_to_group 'shadow'
  end

  it 'should install and start postgres' do
    expect(package('postgresql')).to be_installed
    expect(service('postgresql')).to be_enabled
    expect(service('postgresql')).to be_running
  end

  it 'should install and start docker' do
    expect(service('docker')).to be_enabled
    expect(service('docker')).to be_running
  end

  it 'should install buncker' do
    expect(file('/opt/buncker/bin/buncker')).to be_file
  end
end

