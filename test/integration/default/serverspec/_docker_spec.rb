require 'spec_helper'

describe 'conjurops-jenkins-slave::_docker' do
  it 'creates docker folders in /mnt' do
    %w(/mnt/docker /mnt/docker/tmp).each do |dir|
      expect(file(dir)).to be_directory
      expect(file(dir)).to be_owned_by('jenkins')
    end
  end

  it 'installs docker' do
    expect(command('which docker').stdout).to match /\/usr\/bin\/docker/
  end

  it 'updates docker config to use /mnt/docker as datadir' do
    expect(command('docker info').stdout).to match /Data file: \/mnt\/docker/
  end

  it 'places jenkins in group "docker"' do
    expect(user('jenkins')).to belong_to_group('docker')
  end
end