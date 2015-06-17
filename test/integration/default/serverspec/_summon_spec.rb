require 'spec_helper'

describe 'conjurops-jenkins-slave::_summon' do
  it 'installs summon' do
    expect(command('summon help').stdout).to match(/USAGE:/)
  end

  it 'installs conjurcli driver for summon' do
    expect(command('/usr/libexec/summon/conjurcli.sh').stdout).to match(/No argument received/)
  end
end
