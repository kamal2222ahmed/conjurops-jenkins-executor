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

host_token=$1
host_id=$2
chef_role=/var/chef/roles/host-identity.json

export HOME=/root

echo "Inserting hostfactory token and ID into $chef_role"
sed -i "s/{{HOST_TOKEN}}/${host_token}/" ${chef_role}
sed -i "s/{{HOST_ID}}/${host_id}/" ${chef_role}

echo "Installing the latest version of chef-client"
curl -L https://www.opscode.com/chef/install.sh | sudo bash

echo "Running chef-solo role[host-identity]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-host-identity-chef/releases/download/v1.0.1/conjur-host-identity-chef-v1.0.1.tar.gz -o role[host-identity]

echo "Running chef-solo recipe[conjur-ssh]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-ssh/releases/download/v1.2.3/conjur-ssh-v1.2.3.tar.gz -o conjur-ssh

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

echo "All set!"
