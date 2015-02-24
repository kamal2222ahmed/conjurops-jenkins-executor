apt_repository "webupd8team-java" do
  uri "ppa:webupd8team/java"
  distribution node["lsb"]["codename"]
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "7B2C3B0889BF5709A105D03AC2518248EEA14886"
end

bash "accept Oracle Java license" do
  user "root"
  code "echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"
end

package "oracle-java8-installer"
package "oracle-java8-set-default"
