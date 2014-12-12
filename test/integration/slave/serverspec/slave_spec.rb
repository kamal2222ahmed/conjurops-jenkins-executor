require 'spec_helper'

describe 'conjurops-jenkins::slave' do
  it 'installs git' do
    expect(package('git')).to be_installed
  end

  # it 'installs rvm and rubies 1.9.3 and 2.0.0' do
  #   expect(command('rvm list').stdout).to match /ruby-1.9.3/
  #   expect(command('rvm list').stdout).to match /ruby-2.0.0/
  # end

  it 'installs vagrant v1.7.0 and plugins' do
    expect(command('vagrant version').stdout).to match /Installed Version: 1.7.0/
    expect(command('vagrant plugin list').stdout).to match /vagrant-aws/
    expect(command('vagrant plugin list').stdout).to match /vagrant-omnibus/
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