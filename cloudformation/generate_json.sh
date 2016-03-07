#!/bin/bash -ex

TEMPLATE=$1

docker build -t cloudformation .
docker run --rm -v $PWD:/app cloudformation ./$TEMPLATE expand | tee $TEMPLATE.json
