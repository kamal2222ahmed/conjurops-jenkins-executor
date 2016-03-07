require 'spec_helper'

describe 'conjurops-jenkins-slave::default' do
  it 'runs apt-get update' do
    expect(file('/var/lib/apt/periodic/update-success-stamp')).to be_file
  end

  it 'installs git' do
    expect(package('git')).to be_installed
  end

  it 'installs the Java 8 JDK' do
    expect(command('javac -version').stderr).to match /javac 1.8/
  end

  it 'installs packer' do
    expect(command('packer version').stdout).to match /Packer v0.9/
  end
  
  it 'installs Vagrant' do
    expect(command('vagrant version').stdout).to match /Installed Version: 1.7/
  end

  it 'installs vagrant-aws for jenkins' do
    expect(command('sudo -i -u jenkins vagrant plugin list').stdout).to match /vagrant-aws/
  end
  
  it 'installs vagrant-ami for jenkins' do
    expect(command('sudo -i -u jenkins vagrant plugin list').stdout).to match /vagrant-ami/
  end
  
  it 'installs vagrant-berkshelf for jenkins' do
    expect(command('sudo -i -u jenkins vagrant plugin list').stdout).to match /berkshelf/
  end
  
    
end
