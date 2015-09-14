#!/bin/bash

#
# Bootstraps a publisher slave using Conjur hostfactory
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
host_identity=/var/conjur/host-identity.json

CONJUR_HOST_IDENTITY_VERSION=v1.0.1
CONJUR_SSH_VERSION=v1.2.5

export HOME=/root

echo "Inserting hostfactory token and ID into $host_identity"
sed -i "s/%%HOST_TOKEN%%/${host_token}/" ${host_identity}
sed -i "s/%%HOST_ID%%/${host_id}/" ${host_identity}

echo "Running chef-solo conjur-host-identity"
chef-solo -r https://github.com/conjur-cookbooks/conjur-host-identity/releases/download/${CONJUR_HOST_IDENTITY_VERSION}/conjur-host-identity-${CONJUR_HOST_IDENTITY_VERSION}.tar.gz -j ${host_identity}

echo "Running chef-solo recipe[conjur-ssh]"
chef-solo -r https://github.com/conjur-cookbooks/conjur-ssh/releases/download/${CONJUR_SSH_VERSION}/conjur-ssh-${CONJUR_SSH_VERSION}.tar.gz -o conjur-ssh

# restart nginx for turnon docker registry
service nginx restart

echo "Setting up loggly"
loggly_token=$(/opt/conjur/bin/conjur variable value loggly.com/api-token)
cat << LOGGLY_CONF > /etc/rsyslog.d/22-loggly.conf
\$template LogglyFormat,"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msgid% [${loggly_token}@41058 tag=\"jenkins\" tag=\"slave\"] %msg%\n"
*.*             @@logs-01.loggly.com:514;LogglyFormat
LOGGLY_CONF

service rsyslog restart

echo "All set!"
