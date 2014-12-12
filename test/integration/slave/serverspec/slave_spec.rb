require 'spec_helper'

describe 'conjurops-jenkins::slave' do
  it 'installs git' do
    expect(package('git')).to be_installed
  end

  it 'installs the Java JDK' do
    expect(package('openjdk-6-jdk')).to be_installed
  end

  it 'creates the jenkins user and group' do
    expect(user('jenkins')).to exist
    expect(user('jenkins')).to belong_to_group('jenkins')
    expect(user('jenkins')).to have_home_directory('/mnt/jenkins')
    expect(user('jenkins')).to have_login_shell('/bin/bash')
  end
end