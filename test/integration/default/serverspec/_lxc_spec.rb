require 'spec_helper'

describe 'conjurops-jenkins-slave::_lxc' do
  it 'runs lxc-create' do
    expect(command('sudo lxc-destroy -fn test-1 || true').exit_status).to eq 0
    expect(command('sudo lxc-create -t ubuntu -n test-1').stdout).to match /The default user is/
  end

  it 'runs lxc-start' do
    expect(command('sudo lxc-start -d -n test-1 && sleep 10').exit_status).to eq 0
  end

  it 'runs lxc-ls' do
    expect(command('sudo lxc-ls -f').stdout).to match /NAME/
    expect(command('sudo lxc-ls -f').stdout).to match /test-1/
  end

  it 'runs lxc-info for ip addr' do
    expect(command('sudo lxc-info -iHn test-1 | head -n1').stdout).to match /(?:[0-9]{1,3}\.){3}[0-9]{1,3}/
  end

  it 'runs command inside container' do
    expect(command('sudo lxc-attach -n test-1 -- id').stdout).to match /uid/
  end
end
