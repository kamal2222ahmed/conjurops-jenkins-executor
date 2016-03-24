#!/bin/bash

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
node_name={{ref('NodeName')}}
host_id=$node_name-$(curl http://169.254.169.254/latest/meta-data/instance-id)
host_identity=/var/conjur/host-identity.json

CONJUR_HOST_IDENTITY_VERSION=v1.0.1
CONJUR_SSH_VERSION=v1.2.5
DOCKER_COMPOSE_VERSION=1.6.2

export HOME=/root

echo "Inserting hostfactory token and ID into $host_identity"
sed -i "s/%%HOST_TOKEN%%/${host_token}/" ${host_identity}
sed -i "s/%%HOST_ID%%/${host_id}/" ${host_identity}

echo "Running chef-solo conjur-host-identity]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-host-identity/releases/download/${CONJUR_HOST_IDENTITY_VERSION}/conjur-host-identity-${CONJUR_HOST_IDENTITY_VERSION}.tar.gz -j ${host_identity}

if [ "$node_name" == "executor" ]; then
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
fi

echo "Running chef-solo recipe[conjur-ssh]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-ssh/releases/download/${CONJUR_SSH_VERSION}/conjur-ssh-${CONJUR_SSH_VERSION}.tar.gz -o conjur-ssh

# restart nginx to turn on docker registry
service nginx restart

echo "Launching datadog monitoring agent"
sudo -H -u jenkins bash -c "
summon --yaml 'API_KEY: !var aws/ci/datadog/api-key' \
docker run -d --name dd-agent -h `hostname` \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /proc/:/host/proc/:ro \
-v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
--env-file=@SUMMONENVFILE \
datadog/docker-dd-agent:latest
"

echo "Installing docker-compose"
curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Connecting with Jenkins Swarm plugin"
sudo -H -u jenkins bash -c '
curl -kL -o $HOME/swarm-client.jar \
http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar
'

sudo -H -u jenkins bash -c "
java -jar \$HOME/swarm-client.jar \
-disableSslVerification \
-fsroot /var/lib/jenkins \
-executors 6 \
-labels docker -labels $node_name \
-master https://jenkins.conjur.net \
-name $node_name -mode exclusive \
-username slaves -password $(conjur variable value jenkins/swarm/password) &
"

echo "All set!"
