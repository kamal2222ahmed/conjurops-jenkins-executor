# conjurops-jenkins

## Running locally with Vagrant

Create local Conjur config and .netrc:

    $ conjur init -h conjur-master.itp.conjur.net
    $ conjur authn login

Bring up Jenkins:

    $ vagrant up

Use Jenkins:

    $ open http://localhost:9080
