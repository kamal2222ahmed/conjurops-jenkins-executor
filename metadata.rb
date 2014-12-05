name             'conjurops-jenkins'
maintainer       'The Authors'
maintainer_email 'you@example.com'
license          'all_rights'
description      'Installs/Configures jenkins'
long_description 'Installs/Configures jenkins'
version          '0.1.0'

depends "apt"
depends "build-essential"
depends "conjur-host-identity"
depends "jenkins"
depends "nodejs"
depends "docker"