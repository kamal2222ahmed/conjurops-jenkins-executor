#!/bin/bash

rm -rf .kitchen

export KITCHEN_LOCAL_YAML=.kitchen.ci.yml

kitchen converge
kitchen verify
sleep 10
kitchen destroy || true

