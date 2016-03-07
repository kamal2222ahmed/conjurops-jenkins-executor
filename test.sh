#!/bin/bash -ex

rm -rf .kitchen

kitchen converge
kitchen verify
sleep 10
kitchen destroy || true
