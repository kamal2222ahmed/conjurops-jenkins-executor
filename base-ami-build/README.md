# Base AMI Creation
Files in this directory are used to create an AMI that serves as the basis for the AMIs used to create the Conjur Jenkins build and release slaves images.

## Building
To build the AMI, start by installing [packer](https://www.packer.io/downloads.html).

Then, set the environment variables required to connect to AWS

```shell
$ AWS_ACCESS_KEY_ID=access_key_id
$ AWS_SECRET_ACCESS_KEY=secret_access_key
```

and run packer

```shell
$ packer build packer.json
```

