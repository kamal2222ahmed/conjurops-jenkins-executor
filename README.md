# conjurops-jenkins

Builds a Jenkins server from Chef, ready to run Conjur build and integration processes.

This project is a chef-solo recipe, which is designed to be used in several different workflows:

* Run a local Jenkins in Vagrant, with no authentication.
* Build a Jenkins image (e.g. with Packer), targeting AWS AMI, Docker, LXC, etc.

Obviously there are slight differences between these targets. Details TBD.

# Description

## Base system

* Ubuntu Trusty (14.04) LTS

## Packages

* Jenkins
* Jenkins plugins (attribute `jenkins.plugins`)
* Conjur CLI and API software, server connection configuration, and identity.
* RVM available to Jenkins
* Rubies 1.9.3 and 2.0.0, installed into RVM
* Node.js (for Conjur LDAP service)
* [Buncker](https://github.com/conjurinc/buncker)

## Configuration

* Connect to and trust Conjur (`/etc/conjur.conf`, `/etc/conjur-conjurops.pem`)
* Trust Github
* Trust RVM
* `/etc/sudoers.d/jenkins` allows Jenkins to run Docker and [Buncker](https://github.com/conjurinc/buncker)

## Secrets

* Conjur identity (`/etc/conjur.identity`)

    In a Vagrant environment, the developer's identity is copied to the Jenkins machine. In a production environment, Jenkins needs its own identity.

The remainder of the secrets are fetched from Conjur, using the Conjur API, and injected via the recipes: 

* Jenkins SSH key.

# Running locally with Vagrant

When you run a local Jenkins in Vagrant, Jenkins will use your Conjur identity. You provide your identity to Vagrant by creating the .netrc file in the project directory, then it's shared to `/vagrant` in the normal manner. 

To create a local .netrc:

    $ conjur init -h conjur-master.itp.conjur.net
    $ conjur authn login
    ...
    $ cat .netrc
    [should show the machine entry]

Bring up Jenkins:

    $ vagrant up

Use Jenkins:

    $ open http://localhost:9080
