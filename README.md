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
If you're on OSX, use `docker-machine`, installed as part of the [Docker Toolkbox] (https://www.docker.com/toolbox).

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

Install [Vagrant](http://www.vagrantup.com/downloads.html/) and [Summon](https://github.com/conjurinc/summon/releases).

We create an AMI for this slave so Jenkins can launch it via the Jenkins-EC2 plugin.

To run the official test suite (using `kitchen-ec2`):

```
summon -f secrets.dev.yml ./test.sh
```

(Or, let Jenkins do the work for you).

Then build the AMIs with:

```
./vagrant.sh
```

Refer to the [cloudformation doc](cloudformation/README.md) on how to apply
this new AMI to the `jenkins-slave-cluster` stack.
