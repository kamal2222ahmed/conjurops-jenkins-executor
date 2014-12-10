require 'spec_helper'

jenkins_home = '/var/lib/jenkins'

describe 'conjurops-jenkins::master' do
  it 'should install and start jenkins' do
    expect(package('jenkins')).to be_installed
    expect(service('jenkins')).to be_enabled
    expect(service('jenkins')).to be_running
    expect(port(8080)).to be_listening
  end

  it 'should create group "shadow" and add jenkins user to it' do
    expect(group('shadow')).to exist
    expect(user('jenkins')).to exist
    expect(user('jenkins')).to belong_to_group 'shadow'
  end

  it 'should place the conjur .netrc file for the jenkins user' do
    netrc = "#{jenkins_home}/.netrc"
    expect(file(netrc)).to be_file
    expect(file(netrc)).to be_mode(600)
    expect(file(netrc)).to be_owned_by('jenkins')
  end

  it 'should render a known_hosts file for jenkins user' do
    known_hosts = "#{jenkins_home}/.ssh/known_hosts"
    expect(file(known_hosts)).to be_file
    expect(file(known_hosts)).to be_mode(644)
    expect(file(known_hosts)).to be_owned_by('jenkins')
    expect(file(known_hosts)).to contain /heroku.com/
  end
end

