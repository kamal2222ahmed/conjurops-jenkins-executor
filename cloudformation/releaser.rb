#!/usr/bin/env ruby

require 'cloudformation-ruby-dsl/cfntemplate'

template do

  value :AWSTemplateFormatVersion => '2010-09-09'

  value :Description => 'Jenkins release slave instance and DNS record'

  parameter 'ImageId',
    :Description => 'Base AMI to launch from',
    :Type => 'String'

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

  parameter 'HostedZone',
    :Description => 'The DNS name of an existing Amazon Route 53 hosted zone',
    :Type => 'String'

  parameter 'NodeName',
    :Description => 'Name of the nodes, set in AWS and Jenkins',
    :Type => 'String',
    :Default => 'releaser'

  resource 'EC2Instance', :Type => 'AWS::EC2::Instance', :Properties => {
    :ImageId => ref('ImageId'),
    :InstanceType => ref('InstanceType'),
    :KeyName => 'jenkins-user',
    :SecurityGroups => ['jenkins-slave'],
    # Loads an external userdata script.
    :UserData => base64(interpolate(file('userdata.sh'))),
    :Tags => [
      {
        :Key => 'Name',
        :Value => ref('NodeName')
      }
    ]
  }

  resource 'HostRecord', :Type => 'AWS::Route53::RecordSet', :Properties => {
    :HostedZoneName => join('', ref('HostedZone'), '.'),
    :Name => join('', 'release-slave', '.', ref('HostedZone'), '.'),
    :Type => 'A',
    :TTL => '900',
    :ResourceRecords => [get_att('EC2Instance', 'PublicIp')]
  }

  output 'HostName',
    :Value => ref('HostRecord')

end.exec!
