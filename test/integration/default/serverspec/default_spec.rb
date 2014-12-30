require 'spec_helper'

describe 'conjurops-jenkins-slave::default' do
  it 'runs apt-get update' do
    expect(file('/var/lib/apt/periodic/update-success-stamp')).to be_file
  end

  it 'installs git' do
    expect(package('git')).to be_installed
  end

  it 'installs the Java 6 JDK' do
    expect(package('openjdk-6-jdk')).to be_installed
    expect(command('java -version').stdout).to match /OpenJDK 64-Bit Server VM/
  end

  it 'installs packer' do
    expect(command('packer version').stdout).to match /Packer v0.7.5/
  end
end