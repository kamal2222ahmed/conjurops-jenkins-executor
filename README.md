# conjurops-jenkins

Builds a Jenkins server from Chef, ready to run Conjur build and integration processes.

This project is a chef-solo recipe, which is designed to be used in several different workflows:

* Run a local Jenkins in Vagrant, with no authentication.
* Build and run a remote Jenkins server.
* Build Jenkins images (e.g. AMI, Docker, LXC).

Obviously there are slight differences between these targets. Details (mostly) TBD. Tested workflows are Vagrant-powered local VM, and Vagrant-powered EC2 instance.

# Description

## Base system

* Ubuntu Trusty (14.04) LTS

## Packages

* Jenkins
* Conjur CLI and API software, server connection configuration, and identity.
* Postgresql
* RVM available to Jenkins
* Rubies 1.9.3 and 2.0.0, installed into RVM
* Node.js (for Conjur LDAP service)
* [Buncker](https://github.com/conjurinc/buncker)

## Configuration

* Connect to and trust Conjur (`/etc/conjur.conf`, `/etc/conjur-conjurops.pem`)
* Trust Github
* Trust RVM
* Make `jenkins` a member of the `docker` group

## Secrets

* Conjur identity (`/etc/conjur.identity`)

    In a Vagrant environment, the developer's identity is copied to the Jenkins machine. In a production environment, Jenkins needs its own identity.

The remainder of the secrets are fetched from Conjur, using the Conjur API, and injected via the recipes. Jobs are configured to use [conjur env run](http://developer.conjur.net/reference/tools/conjurenv/run.html), a la `conjur env run -- job-script.sh`.

# Running locally with Vagrant

When you run a local Jenkins in Vagrant, Jenkins will use your Conjur identity. You provide your identity to Vagrant by creating the .netrc file in the project directory, then it's shared to `/vagrant` in the normal manner.

To create a local .netrc:

```
conjur init -h conjur-master.itp.conjur.net
conjur authn login
    ...
cat .netrc
[should show the machine entry]
```

Bring up Jenkins:

    $ vagrant up

Use Jenkins:

    $ open http://localhost:9080

# Running locally with test-kitchen

Install the [ChefDK](https://downloads.chef.io/chef-dk/) and activate it. You should have docker running locally.
If you're on OSX, use [boot2docker](https://github.com/boot2docker/osx-installer/releases).

Copy your `~/.netrc` file to this project directory.

To bring the Jenkins master up:

```
kitchen converge master
```

Visit the UI at `[machine running the docker service]:8080`.

To run tests:

```
kitchen verify master
```

Log in with `kitchen login master`. Password is 'kitchen'.

When you're all done, run `kitchen destroy master`.

Same process with the Jenkins slave, just use 'slave' instead of 'master' for the kitchen commands.
---

check `LAUNCH.md` for instruction on how to launch the machine
