#!/bin/bash

rm -rf .vendor

berks vendor .vendor/cookbooks

conjur env run -- packer build packer.json
