# Cleanup before AMI build.
# Don't run in other environments as it deletes keys
# and cuts off ssh access to the VM.

%w(/root/.ssh /root/.gnupg /home/ubuntu/.ssh /home/ubuntu/.gnupg).each do |dir|
  directory dir do
    action :delete
    recursive true
  end
end

bash 'remove logfiles' do
  code "find /var/log -type f -exec rm '{}' ';'"
end
