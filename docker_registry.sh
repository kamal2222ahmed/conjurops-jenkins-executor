#!/bin/bash -e

# Launch this on a fresh slave VM to set it up for pulling from
# the Conjur private Docker registry.
# USE THIS IN DEVELOPMENT ONLY!!!

if ! grep -q 'registry.tld' '/etc/hosts'; then
  sudo echo '127.0.0. registry.tld registry' >> /etc/hosts
fi

conjur init -h conjur-master.itp.conjur.net
cat << CONF > /etc/default/docker
DOCKER_OPTS="--tls=false -H 0.0.0.0:2375 --insecure-registry registry --insecure-registry registry.tld"
CONF
cat << CONF > /etc/conjur.conf
---
account: conjurops
plugins: []
appliance_url: https://conjur-master.itp.conjur.net/api
cert_file: "/etc/conjur-conjurops.pem"
netrc_path: "/etc/conjur.identity"
CONF
usermod -G docker,conjur vagrant
touch /etc/conjur.identity
chmod 0640 /etc/conjur.identity
chown root:conjur /etc/conjur.identity
conjur authn login



echo "Log out and in again to apply group changes."
