#!/usr/bin/env ruby

require 'cloudformation-ruby-dsl/cfntemplate'

template do

  value :AWSTemplateFormatVersion => '2010-09-09'

  value :Description => 'Jenkins slave autoscaling group'

  parameter 'ImageId',
    :Description => 'Base AMI to launch from',
    :Type => 'String'

  parameter 'DesiredCapacity',
    :Description => 'Desired number of slaves to launch',
    :Type => 'String',
    :Default => '1'

  parameter 'HostFactoryToken',
    :Description => 'Conjur hostfactory token to use to launch hosts',
    :Type => 'String'

  parameter 'KeyName',
    :Description => 'Name of an existing EC2 KeyPair to enable SSH access to the instance',
    :Type => 'AWS::EC2::KeyPair::KeyName',
    :Default => 'jenkins-user',
    :ConstraintDescription => 'must be the name of an existing EC2 KeyPair.'

  parameter 'InstanceType',
    :Description => 'WebServer EC2 instance type',
    :Type => 'String',
    :Default => 'm3.medium',
    :AllowedValues => %w(m3.medium m3.large),
    :ConstraintDescription => 'must be a valid EC2 instance type.'

  resource 'ASG', :Type => 'AWS::AutoScaling::AutoScalingGroup', :Properties => {
    :AvailabilityZones => ['us-east-1a'],
    :HealthCheckType => 'EC2',
    :LaunchConfigurationName => ref('LaunchConfig'),
    :DesiredCapacity => ref('DesiredCapacity'),
    :MinSize => 1,
    :MaxSize => 5,
    :Tags => [
      {
        :Key => 'Name',
        # Grabs a value in an external map file.
        :Value => 'jenkins-slave',
        :PropagateAtLaunch => 'true',
      }
    ]
  }

  resource 'LaunchConfig', :Type => 'AWS::AutoScaling::LaunchConfiguration', :Properties => {
    :ImageId => ref('ImageId'),
    :InstanceType => ref('InstanceType'),
    :KeyName => 'jenkins-user',
    :SecurityGroups => ['jenkins-slave'],
    # Loads an external userdata script.
    :UserData => base64(interpolate(file('userdata.sh')))
  }

end.exec!
