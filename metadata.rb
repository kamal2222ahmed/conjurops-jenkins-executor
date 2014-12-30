name             'conjurops-jenkins-slave'
maintainer       'The Authors'
maintainer_email 'you@example.com'
license          'all_rights'
description      'Installs/Configures jenkins slave'
long_description 'Installs/Configures jenkins slave'
version          '0.1.3'

supports 'ubuntu'

depends 'apt', '~> 2.6.0'
depends 'conjur-client'
depends 'packer', '~> 0.3.0'