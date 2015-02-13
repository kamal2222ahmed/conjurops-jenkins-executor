# Creating and updating the Jenkins slave cluster

## Creating/modifying the stack itself

We're using the [cloudformation-ruby-dsl](https://github.com/bazaarvoice/cloudformation-ruby-dsl) library to define the CloudFormation stack in Ruby, [jenkins-slave.rb](jenkins-slave.rb).

We then run conversion to JSON in a Docker container.

```sh-session
$ docker build -t cloudformation .
$ docker run -t cloudformation > jenkins-slave.json
```

Create a new stack or update the existing one using 'jenkins-slave.json' at the
[Cloudformation dashboard](https://console.aws.amazon.com/cloudformation/home?region=us-east-1)
for the Conjur CI AWS account.

## Updating the cluster instance(s)

When we create a new version of this cookbook we'll want to generate a new AMI
via packer. This happens [automatically in Jenkins](http://jenkins.conjur.net:8080/job/conjurops-jenkins-slave-image/) on git push.

Once we have an AMI built, we want to update the `jenkins-slave-cluster` stack in the
Conjur CI AWS [Cloudformation dashboard](https://console.aws.amazon.com/cloudformation/home?region=us-east-1).

To update to the new AMI:

1. Select the `jenkins-slave-cluster` stack and click 'Update Stack'.
2. For source, leave 'Use existing template' selected and click 'Next'.
3. Update the ImageId parameter to the new AMI ID - this is in the Jenkins log for the build linked above.
4. Click 'Next' through all subsequent screens and then click 'Update'.
5. When the stack status says 'UPDATE_COMPLETE' you are done.
6. Switch to the [EC2 dashboard](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:tag:Name=jenkins-slave;sort=launchTime).
7. Terminate any instances with Name 'jenkins-slave'. They will come back up with the new AMI.
8. Update the 'Host' field in in the [slave config in Jenkins](http://jenkins.conjur.net:8080/computer/jenkins-slave/) to point to the new instance public DNS.

## Scaling the cluster

If you want to scale up the number of slaves, go to the CloudFormation dashboard
and update the existing stack, leaving 'Use existing template' checked. Update the
'DesiredCapacity' parameter and the slave cluster will launch/terminate instances to this
number. Min is 1, max is 5.