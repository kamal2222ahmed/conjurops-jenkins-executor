name             'conjurops-jenkins-slave'
maintainer       'Conjur Inc'
maintainer_email 'support@conjur.net'
license          'Restricted'
description      'Installs/Configures jenkins slave'
long_description 'Installs/Configures jenkins slave'
version          '0.4.0'

supports 'ubuntu'

depends 'apt', '~> 2.6.0'
depends 'conjur-client'
depends 'packer', '~> 0.3.0'
depends 'sudo', '~> 2.7.1'
depends 'ssh_known_hosts'
