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
    $ conjur resource annotate host:ec2/i-47bb72ae name "KEG Development Jenkins"
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

Login as self:

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

---

# Launching a Jenkins slave on EC2

## Setup

Install and activate [ChefDK](https://downloads.chef.io/chef-dk/).

```
chef gem install knife-ec2
```

Default values are set in `knife.rb` and can be overridden with [command-line flags](https://github.com/opscode/knife-ec2#configuration).

## Launching

```
conjur env run -- knife ec2 server create --ssh-key [key-name] --identity-file [private-key]
```

where `key-name` is the name of your EC2 keypair and
`private-key` is the path to your AWS .pem file.

It will throw this error: `ERROR: Errno::ENOENT: No such file or directory @ rb_sysopen - /etc/chef/validation.pem`.
You can ignore this, since we're not using a Chef server.

The script will give you the instance's endpoint.
You can now log into your instance as ubuntu user with

```
ssh [instance-endpoint] -i [private-key]
```

You can view instances with

`conjur env run -- knife ec2 server list` and delete them with

`conjur env run -- knife ec2 server [instance-id]`.

## Provisioning

Install [chef-runner](https://github.com/mlafeldt/chef-runner).

You can apply recipes remotely with Chef runner.
Set up your `~/.ssh/config` to pass the right credentials to the server if needed.

For example, running the slave recipe:

```
chef exec chef-runner -H ubuntu@ec2-174-129-84-24.compute-1.amazonaws.com -i true conjurops-jenkins::slave
```

The `-i` flag is telling Chef runner to install the latest version of Chef on the machine, if it doesn't exist.

The server is arbitrary, as long as you have SSH access you can apply Chef recipes to it.
**Important:** you must use `chef exec` to run these commands so the right libraries are available (berkshelf, etc).
