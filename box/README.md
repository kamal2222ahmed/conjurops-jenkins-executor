# Launching an EC2 instance via Vagrant

## Setup

```
vagrant plugin install vagrant-aws
vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
```

## Usage

```
conjur env run -- vagrant up --provider aws
```
