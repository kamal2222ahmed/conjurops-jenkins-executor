#!/bin/bash

rm -rf .kitchen

export KITCHEN_LOCAL_YAML=.kitchen.ci.yml

summon -f secrets.ci.yml kitchen converge
summon -f secrets.ci.yml kitchen verify
sleep 10
summon -f secrets.ci.yml kitchen destroy || true

