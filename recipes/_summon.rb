package "unzip"
package "curl"

execute "install summon" do
  command "curl -L -o summon.zip https://github.com/conjurinc/summon/releases/download/v#{node.summon.version}/summon_v#{node.summon.version}_linux_amd64.zip && unzip summon.zip && chmod a+x summon"
  creates "/usr/local/bin/summon"
  cwd "/usr/local/bin"
end

directory "/usr/libexec/summon" do
  recursive true
end

execute "install conjur-cli driver for summon" do
  command "curl -L -o conjurcli.sh https://raw.githubusercontent.com/conjurinc/summon-conjurcli/master/conjurcli.sh && chmod a+x conjurcli.sh"
  cwd "/usr/libexec/summon"
  creates "/usr/libexec/summon/conjurcli.sh"
end
