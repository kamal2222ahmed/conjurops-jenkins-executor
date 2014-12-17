#!/bin/bash

rm -rf .vendor

berks vendor .vendor/cookbooks

export GIT_HASH=$(git rev-parse HEAD)

conjur env run -- packer build $@ packer.json
