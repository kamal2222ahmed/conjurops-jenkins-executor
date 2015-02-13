# conjurops-jenkins-slave

Builds a Jenkins slave from Chef, ready to run Conjur build and integration processes.

* Creates a Jenkins user
* Installs OpenJDK 6 and docker
* Places conjur configuration files

## Requirements

### Platform

* Ubuntu Trusty (14.04) LTS

### Cookbooks

* [apt](https://github.com/opscode-cookbooks/apt)

## Usage

Run the `conjurops-jenkins-slave` recipe.

## Development

### Setup

Install the [ChefDK](https://downloads.chef.io/chef-dk/) and activate it. You should have docker running locally.
If you're on OSX, use [boot2docker](https://github.com/boot2docker/osx-installer/releases).

Run `chef exec bundle install` to get the correct test-kitchen driver.

### Testing

Bring the container up:

```
kitchen converge
```

This project directory is shared into the container at `/home/kitchen/project`.

Run the [serverspec](http://serverspec.org) tests:

```
kitchen verify
```

Log into the container with `kitchen login`. The password is "kitchen".

When you're all done run `kitchen destroy` to remove the container.

---

## Creating an AMI

### Setup

Install [packer](https://www.packer.io/) and run `conjur env check` to ensure you have
access to the AWS credentials.

We create an AMI for this slave so Jenkins can launch it via the Jenkins-EC2 plugin.

To build a new AMI run

```
./packer.sh
```

This will create an instance, converge the `conjurops-jenkins-slave` on it,
create the AMI and destroy the source instance. All events are output to stdout
by packer.

Refer to the [cloudformation doc](cloudformation/README.md) on how to apply
this new AMI to the `jenkins-slave-cluster` stack.

## Creating a one-off slave

Describe the base image, to get the root block device info:

    $ conjur env run -c ~/aws-ci-root.secrets -- aws ec2 describe-images --image-ids ami-9eaa1cf6
    ..
    {
        "DeviceName": "/dev/sda1",
        "Ebs": {
            "DeleteOnTermination": true,
            "SnapshotId": "snap-1f806dbb",
            "VolumeSize": 8,
            "VolumeType": "gp2",
            "Encrypted": false
        }
    }

Create a development instance with an 80 GB root volume:

    $ conjur env run -c ~/aws-ci-root.secrets -- aws ec2 run-instances --image-id ami-9eaa1cf6 \
      --instance-type m3.medium --key-name spudling \
      --block-device-mappings "{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"SnapshotId\":\"snap-1f806dbb\",\"VolumeSize\":80}}"

Provision the instance with `chef-runner`:

    $ chef shell-init bash
    $ ssh-add <key-name>
    $ berks install
    $ chef-runner -H ubuntu@ec2-54-159-236-142.compute-1.amazonaws.com conjurops-jenkins-slave

At this point, there's an instance with the base recipes. To make it a working slave, it needs an identity.

SSH to the machine and bootstrap it. You'll need a [host factory token](http://developer.conjur.net/reference/services/host_factory).

    $ ssh ubuntu@ec2-54-159-236-142.compute-1.amazonaws.com
    Logged in
    $ sudo -i
    # instanceid=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
    # /opt/conjur-bootstrap 3vn0ve53tb2x3k03cf6wq537m53am $instanceid
    ...
    Recipe: conjur-host-identity-chef::default
    Chef Client finished, 3/5 resources updated in 21.394282096 seconds
    Running chef-solo recipe[conjur-ssh]
    ...
    Chef Client finished, 38/58 resources updated in 26.312613544 seconds
    Placing jenkins' private key so it can clone repos
    All set!
    # export PATH=/opt/conjur/bin:$PATH
    # conjur authn whoami
    {"account":"conjurops","username":"host/ec2/i-6f316591"}