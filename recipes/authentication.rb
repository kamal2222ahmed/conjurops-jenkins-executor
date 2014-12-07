# Required for Unix authentication
group "shadow" do
  append true
  members [ "jenkins" ]
  action :modify
end

# TODO: Allow PasswordAuthentication
ruby_block "permit password-based login" do
  block do
    lines = File.read("/etc/ssh/sshd_config").split("\n")
    lines.each_index do |i|
      if lines[i] =~ /PasswordAuthentication/
        lines[i] = "PasswordAuthentication yes"
      end
    end
    File.write("/etc/ssh/sshd_config", lines.join("\n"))
  end
end

service "ssh" do
  action [ :enable, :restart ]
end

directory "/var/lib/jenkins/.ssh" do
  user 'jenkins'
end
