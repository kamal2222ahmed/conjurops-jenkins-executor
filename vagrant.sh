#!/bin/bash -ex

set -o pipefail
export GIT_HASH=$(git rev-parse HEAD)
export GIT_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)

types="slave release_slave"
cleanup_types="$types"

cleanup() {
  for m in $cleanup_types; do
    vagrant destroy -f $m
  done
}
trap cleanup EXIT

wait_all() {
  jobs="$@"
  for j in $jobs; do
    wait $j || exit 1
  done
}

for m in $types; do
  vagrant up --provider=aws $m 2>&1 | tee -a ${m}.log
done

jobs=""
for m in $types; do
  tags="git_hash=$GIT_HASH,git_tag=$GIT_TAG,conjur/app=conjurops-jenkins-${m},created_by=$USER"

  ami_name="${m}_$(date +"%s")"
  (set -o ; vagrant create-ami --name "conjurops-jenkins-$ami_name" --desc "$ami_name" --tags "$tags" $m 2>&1 | tee -a ${m}.log) &
  jobs+=" $!"
done
wait_all $jobs

exit 0
