name             'conjurops-jenkins-slave'
maintainer       'Conjur Inc'
maintainer_email 'support@conjur.net'
license          'Restricted'
description      'Installs/Configures jenkins slave'
long_description 'Installs/Configures jenkins slave'
version          '0.1.6'

supports 'ubuntu'

depends 'apt', '~> 2.6.0'
depends 'conjur-client'
depends 'packer', '~> 0.3.0'
