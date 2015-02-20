require 'spec_helper'

describe 'conjurops-jenkins-slave::_nginx' do
  it 'nginx is installed' do
    expect(command('which nginx').stdout).to match /\/usr\/sbin\/nginx/
  end
end
