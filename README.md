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
