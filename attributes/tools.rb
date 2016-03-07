# Tools installed on the Jenkins slave

CHEFDK_VERSION =      '0.11.0-1'
CONJUR_CLI_VERSION =  '4.30.1-1'
DOCKER_VERSION =      '1.9.1-0~trusty'
PACKER_VERSION =      '0.9.0'
SUMMON_VERSION =      '0.4.0'
VAGRANT_VERSION =     '1.7.4'

default['chefdk']['url'] = "https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_#{CHEFDK_VERSION}_amd64.deb"

default['conjur']['version'] = CONJUR_CLI_VERSION
default['conjur']['configuration']['account'] = 'conjurops'
default['conjur']['configuration']['appliance_url'] = 'https://conjur-master.itp.conjur.net/api'
default['conjur']['configuration']['plugins'] = []
default['conjur']['configuration']['ssl_certificate'] = "-----BEGIN CERTIFICATE-----\nMIIDUTCCAjmgAwIBAgIJAO4Lf1Rf2cciMA0GCSqGSIb3DQEBBQUAMDMxMTAvBgNV\nBAMTKGVjMi01NC05MS0yNDYtODQuY29tcHV0ZS0xLmFtYXpvbmF3cy5jb20wHhcN\nMTQxMDA4MjEwNTA5WhcNMjQxMDA1MjEwNTA5WjAzMTEwLwYDVQQDEyhlYzItNTQt\nOTEtMjQ2LTg0LmNvbXB1dGUtMS5hbWF6b25hd3MuY29tMIIBIjANBgkqhkiG9w0B\nAQEFAAOCAQ8AMIIBCgKCAQEAx+OFANXNEYNsMR3Uvg4/72VG3LZO8yxrYaYzc3FZ\nNN3NpIOCZvRTC5S+OawsdEljHwfhdVoXdWNKgVJakSxsAnnaj11fA6XpfN60o6Fk\ni4q/BqwqgeNJjKAlElFsNz2scWFWRe49NHlj9qaq/yWZ8Cn0IeHy8j8F+jMek4zt\ndCSxVEayVG/k8RFmYCcluQc/1LuCjPiFwJU43AGkO+yvmOuYGivsNKY+54yuEZqF\nVDsjAjMsYXxgLx9y1F7Rq3CfeqY6IajR7pmmRup8/D9NyyyQuIML83mjTSvo0UYu\nrkdXPObd/m6gumscvXMl6SoJ5IPItvTA42MZqTaNzimF0QIDAQABo2gwZjBkBgNV\nHREEXTBbgglsb2NhbGhvc3SCBmNvbmp1coIcY29uanVyLW1hc3Rlci5pdHAuY29u\nanVyLm5ldIIoZWMyLTU0LTkxLTI0Ni04NC5jb21wdXRlLTEuYW1hem9uYXdzLmNv\nbTANBgkqhkiG9w0BAQUFAAOCAQEANk7P3ZEZHLgiTrLG13VAkm33FAvFzRG6akx1\njgNeRDgSaxRtrfJq3mnhsmD6hdvv+e6prPCFOjeEDheyCZyQDESdVEJBwytHVjnH\ndbvgMRaPm6OO8CyRyNjg3YcC36T//oQKOdAXXEcrtd0QbelBDYlKA7smJtznfhAb\nXypVdeS/6I4qvJi3Ckp5sQ1GszYhVXAvEeWeY59WwsTWYHLkzss9QShnigPyo3LY\nZA5JVXofYi9DJ6VexP7sJNhCMrY2WnMpPcAOB9T7a6lcoXj6mWxvFys0xDIEOnc6\nNGb+d47blphUKRZMAUZgYgFfMfmlyu1IXj03J8AuKtIMEwkXAA==\n-----END CERTIFICATE-----\n"

default['docker']['version'] = DOCKER_VERSION

default['packer']['version'] = "packer_#{PACKER_VERSION}"
default['packer']['checksum'] = '4119d711855e8b85edb37f2299311f08c215fca884d3e941433f85081387e17c'
default['packer']['url_base'] = "https://releases.hashicorp.com/packer/#{PACKER_VERSION}"

default['summon']['version'] = SUMMON_VERSION

default['vagrant']['version'] = VAGRANT_VERSION
default['vagrant']['url'] = "https://releases.hashicorp.com/vagrant/#{VAGRANT_VERSION}/vagrant_#{VAGRANT_VERSION}_x86_64.deb"
default['vagrant']['checksum'] = 'dcd2c2b5d7ae2183d82b8b363979901474ba8d2006410576ada89d7fa7668336'
