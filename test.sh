#!/bin/bash

rm -rf .kitchen

export KITCHEN_LOCAL_YAML=.kitchen.ci.yml
secrets=${SECRETS_YAML:-secrets.ci.yml}

# kitchen expects the SSH key to be in the same place from one run to
# the next. Put it in a file, delete it when we're done.
summon -f "$secrets" bash -c 'echo "$SSH_PRIVATE_KEY" > private_key'
chmod 0600 private_key
trap "rm private_key" EXIT

summon -f "$secrets" kitchen converge
summon -f "$secrets" kitchen verify
sleep 10
summon -f "$secrets" kitchen destroy || true

