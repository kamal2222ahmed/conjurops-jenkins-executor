require 'spec_helper'

describe 'conjurops-jenkins-slave::_docker' do
  it 'installs docker' do
    expect(command('which docker').stdout).to match /\/usr\/bin\/docker/
    expect(command('docker ps').stdout).to match /CONTAINER ID/
  end

  it 'places jenkins in group "docker"' do
    expect(user('jenkins')).to belong_to_group('docker')
  end
end