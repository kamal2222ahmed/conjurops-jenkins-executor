package "curl"

execute "install summon" do
  cwd "/usr/local/bin"
  command <<-CODE
  curl -L -o summon.tar.gz https://github.com/conjurinc/summon/releases/download/v#{node.summon.version}/summon_v#{node.summon.version}_linux_amd64.tar.gz && \
  tar -zxvf summon.tar.gz && \
  chmod a+x summon
  CODE
  creates "/usr/local/bin/summon"
end

provider_dir = '/usr/local/lib/summon'

directory provider_dir do
  recursive true
end

execute "install conjur-cli driver for summon" do
  cwd provider_dir
  command <<-CODE
  curl -L -o conjurcli.sh https://raw.githubusercontent.com/conjurinc/summon-conjurcli/master/conjurcli.sh && \
  chmod a+x conjurcli.sh
  CODE
  creates "#{provider_dir}/conjurcli.sh"
end
