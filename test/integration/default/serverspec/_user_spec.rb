require 'spec_helper'

jenkins_home = '/var/lib/jenkins'

describe 'conjurops-jenkins-slave::_user' do
  it 'creates the jenkins user and group' do
    expect(user('jenkins')).to exist
    expect(user('jenkins')).to belong_to_group('jenkins')
    expect(user('jenkins')).to have_home_directory(jenkins_home)
    expect(file(jenkins_home)).to be_directory
    expect(user('jenkins')).to have_login_shell('/bin/bash')
  end

  it 'places jenkins user in group "shadow"' do
    expect(user('jenkins')).to belong_to_group('shadow')
  end

  it 'places jenkins\' known_hosts file' do
    expect(file("#{jenkins_home}/.ssh/known_hosts")).to be_file
    expect(file("#{jenkins_home}/.ssh/known_hosts").content).to match /heroku.com/
  end
end
