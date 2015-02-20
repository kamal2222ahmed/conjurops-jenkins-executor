require 'spec_helper'

describe 'conjurops-jenkins-slave::_registry' do
  it 'registry configs is in place' do
    expect(file("/etc/nginx/conf.d/lua.conf")).to be_file
    expect(file("/etc/nginx/sites-enabled/registry.conf")).to be_file
  end
end
