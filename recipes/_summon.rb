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

directory "/usr/libexec/summon" do
  recursive true
end

execute "install conjur-cli driver for summon" do
  cwd "/usr/libexec/summon"
  command <<-CODE
  curl -L -o conjurcli.sh https://raw.githubusercontent.com/conjurinc/summon-conjurcli/master/conjurcli.sh && \
  chmod a+x conjurcli.sh
  CODE
  creates "/usr/libexec/summon/conjurcli.sh"
end
