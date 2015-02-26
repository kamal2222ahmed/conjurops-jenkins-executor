#!/bin/bash

# ./conjur-bootstrap
#
# Bootstraps a Jenkins slave using Conjur hostfactory
#
# This script takes 2 arguments
# 1. The Conjur hostfactory token
# 2. The ID of the instance, this will show up in Conjur as "host/myid". This ID must be unique.
#
# Example Usage:
# bash /opt/conjur-bootstrap.sh 3tsccy121wvsqm1xejtjdurh28dmc5s8v633vckrswrtg8q1j7gwre i-f3432b1f
#

set -e

host_token={{ref('HostFactoryToken')}}
host_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
chef_role=/var/chef/roles/host-identity.json

CONJUR_HOST_IDENTITY_VERSION=v1.0.1
CONJUR_SSH_VERSION=v1.2.5

export HOME=/root

echo "Inserting hostfactory token and ID into $chef_role"
sed -i "s/%%HOST_TOKEN%%/${host_token}/" ${chef_role}
sed -i "s/%%HOST_ID%%/${host_id}/" ${chef_role}

echo "Running chef-solo role[host-identity]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-host-identity/releases/download/${CONJUR_HOST_IDENTITY_VERSION}/conjur-host-identity-${CONJUR_HOST_IDENTITY_VERSION}.tar.gz -o role[host-identity]

echo "Placing jenkins key material"
chown -R jenkins:jenkins /var/lib/jenkins
ssh_dir=/var/lib/jenkins/.ssh
cd $ssh_dir
/opt/conjur/bin/conjur variable value jenkins/private-key > id_rsa
chmod 600 id_rsa
ssh-keygen -y -f id_rsa > id_rsa.pub
ssh-keygen -y -f id_rsa > authorized_keys
chown -R jenkins:jenkins $ssh_dir
chmod 644 id_rsa.pub
chmod 640 authorized_keys

echo "Running chef-solo recipe[conjur-ssh]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-ssh/releases/download/${CONJUR_SSH_VERSION}/conjur-ssh-${CONJUR_SSH_VERSION}.tar.gz -o conjur-ssh

# restart nginx for turnon docker registry
service nginx restart

echo "Setting up loggly"
export LINUX_DO_VERIFICATION=false # I haven't any ideas what to do with this schlock - it very annoying me, so, just turn of verification step where invokes: https://www.pivotaltracker.com/story/show/89088980
loggly_pass=$(/opt/conjur/bin/conjur variable value loggly.com/password)
curl -O https://www.loggly.com/install/configure-linux.sh
bash configure-linux.sh -a conjur -u conjur -p ${loggly_pass}

# Add the tags 'jenkins' and 'slave' to make log searching easier
sed -i 's/] %msg%/ tag=\\\"jenkins\\\" tag=\\\"slave\\\"] %msg%/g' /etc/rsyslog.d/22-loggly.conf

service rsyslog restart

echo "All set!"
