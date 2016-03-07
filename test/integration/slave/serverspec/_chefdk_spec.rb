require 'spec_helper'

describe 'conjurops-jenkins-slave::_chefdk' do
  it 'installs ChefDK without errors' do
    expect(command('chef verify').exit_status).to eq 0
  end

  it 'installs the kitchen-docker driver' do
    expect(command('chef gem list | grep kitchen-docker').exit_status).to eq 0
  end

  it 'makes chef, berks and kitchen commands available' do
    %w(chef berks kitchen).each do |c|
      expect(command("#{c} -v").exit_status).to eq 0
    end
  end
end
