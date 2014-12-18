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
echo "Inserting hostfactory token and ID into $chef_role"
sed -i "s/{{HOST_TOKEN}}/${host_token}/" ${chef_role}
sed -i "s/{{HOST_ID}}/${host_id}/" ${chef_role}

export HOME=/root

echo "Moving the jenkins home dir to /mnt/jenkins to get more space"
usermod -m -d /mnt/jenkins jenkins

echo "Installing the latest version of chef-client"
curl -L https://www.opscode.com/chef/install.sh | sudo bash

echo "Running chef-solo role[host-identity]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-host-identity-chef/releases/download/v1.0.1/conjur-host-identity-chef-v1.0.1.tar.gz -o role[host-identity]

echo "Running chef-solo recipe[conjur-ssh]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-ssh/releases/download/v1.2.3/conjur-ssh-v1.2.3.tar.gz -o conjur-ssh

echo "Placing jenkins' private key so it can clone repos"
pem=/mnt/jenkins/.ssh/id_rsa
conjur variable value jenkins/private-key > /tmp/id_rsa
mv /tmp/id_rsa ${pem}
chown jenkins:jenkins ${pem}
chmod 600 ${pem}

chown -R jenkins:jenkins /mnt/jenkins

echo "All set!"
