require 'spec_helper'

describe 'conjurops-jenkins-slave::_docker' do
  it 'installs docker' do
    expect(command('which docker').stdout).to match /\/usr\/bin\/docker/
  end

  it 'places jenkins in group "docker"' do
    expect(user('jenkins')).to belong_to_group('docker')
  end

  it 'uses AUFS for docker storage' do
    expect(command('docker info | grep "Storage Driver" | awk "{print $3}"').stdout).to match /aufs/
  end
  
end
