#!/bin/bash

rm -rf .vendor

berks vendor .vendor/cookbooks

git_hash=$(git rev-parse HEAD)

conjur env run -- packer build -var 'git_hash=${git_hash}' packer.json
