#!/bin/bash

rm -rf .vendor

berks vendor .vendor/cookbooks

export GIT_HASH=$(git rev-parse HEAD)
export GIT_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)

conjur env run -- packer build $@ packer.json
