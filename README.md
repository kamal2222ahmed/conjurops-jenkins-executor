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

# Build a remote server in EC2

## Build the Vagrant box for AWS

    $ tar cvzf aws.box -Cbox metadata.json Vagrantfile
    $ vagrant box add trusty64 aws.box

## Launch the machine

Create secrets file. For example:

    aws_keypair_name: spudling
    aws_access_key_id: !var aws/dev/sys_powerful/access_key_id
    aws_secret_access_key: !var aws/dev/sys_powerful/secret_access_key
    ssh_private_key_path: ~/.ssh/conjur_dev_spudling.pem

Launch the machine:  

    $ conjur env run -c aws.secrets -- vagrant up master --provider aws

Create the Conjur host identity:

    $ conjur host create ec2/i-47bb72ae | tee host.json
    $ conjur resource annotate host:ec2/i-47bb72ae name "KEG Development Jenkins Recovery [0]"
    $ conjur resource annotate host:ec2/i-47bb72ae jenkins.url "http://54.237.61.96:8080"
    
Install and configure Conjur on the machine:

    $ cat host.json | conjurize --ssh --sudo --chef-executable /opt/chef/bin/chef-solo | ssh -i /Users/kgilpin/.ssh/conjur_dev_spudling.pem ubuntu@54.237.61.96

Login to the machine (confirm that it works with your own private key):

    $ ssh 54.237.61.96
    Creating directory '/home/kgilpin'.
    ...
    kgilpin@ip-10-169-136-74:~$ sudo -i
    root@ip-10-169-136-74:~# 
    
## Configure Jenkins security

    * Enable security
    * Enable Unix or LDAP authentication
    * Enable matrix-based authorization
    
# Production deployment

Create the host record:

    $ conjur host create --as-group v4/build jenkins-001.itci.conjur.net | tee jenkins-001.itci.conjur.net.json
    {
      "id": "jenkins-001.itci.conjur.net",
      "userid": "kgilpin",
      "created_at": "2014-12-07T17:10:27Z",
      "ownerid": "conjurops:group:v4/build",
      "roleid": "conjurops:host:jenkins-001.itci.conjur.net",
      "resource_identifier": "conjurops:host:jenkins-001.itci.conjur.net",
      "api_key": "(snip)"
    }
    $ conjur layer hosts add build-0.1.0/jenkins jenkins-001.itci.conjur.net
    Host added

Conjurize the host:
    
    $ cat jenkins-001.itci.conjur.net.json | conjurize --sudo --ssh --chef-executable /opt/chef/bin/chef-solo | ssh -i /Users/kgilpin/.ssh/conjur_ci-jenkins.pem ubuntu@jenkins-001.itci.conjur.net
    ...
    [2014-12-07T17:10:47+00:00] INFO: Running report handlers
    [2014-12-07T17:10:47+00:00] INFO: Report handlers complete

Login as self!

    kgilpin@spudling $ ssh jenkins-001.itci.conjur.net
    ...
    kgilpin@ip-10-169-122-235:~$ 

## Correct some Cookbook problems

* Fix `/etc/conjur.identity` formatting
* Permissive `netrc` permissions for `/etc/conjur.identity`

## Upgrade Conjur

    # cd /mnt
    # curl -o conjur.deb https://s3.amazonaws.com/conjur-releases/omnibus/conjur_4.17.0-5_amd64.deb
    # dpkg -i conjur.deb
    # GLI_DEBUG=true /opt/conjur/bin/conjur authn whoami
    {"account":"conjurops","username":"host/jenkins-001.itci.conjur.net"

