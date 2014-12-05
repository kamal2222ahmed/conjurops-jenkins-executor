default['jenkins']['master']['install_method'] = 'package' 
  
default['docker']['package']['repo_url'] = 'https://get.docker.io/ubuntu'

default['conjur']['version'] = '4.17.0'
default['conjur']['configuration']['account'] = 'conjurops'
default['conjur']['configuration']['appliance_url'] = 'https://conjur-master.itp.conjur.net/api'
default['conjur']['configuration']['plugins'] = []
default['conjur']['configuration']['ssl_certificate'] = "-----BEGIN CERTIFICATE-----\nMIIDUTCCAjmgAwIBAgIJAO4Lf1Rf2cciMA0GCSqGSIb3DQEBBQUAMDMxMTAvBgNV\nBAMTKGVjMi01NC05MS0yNDYtODQuY29tcHV0ZS0xLmFtYXpvbmF3cy5jb20wHhcN\nMTQxMDA4MjEwNTA5WhcNMjQxMDA1MjEwNTA5WjAzMTEwLwYDVQQDEyhlYzItNTQt\nOTEtMjQ2LTg0LmNvbXB1dGUtMS5hbWF6b25hd3MuY29tMIIBIjANBgkqhkiG9w0B\nAQEFAAOCAQ8AMIIBCgKCAQEAx+OFANXNEYNsMR3Uvg4/72VG3LZO8yxrYaYzc3FZ\nNN3NpIOCZvRTC5S+OawsdEljHwfhdVoXdWNKgVJakSxsAnnaj11fA6XpfN60o6Fk\ni4q/BqwqgeNJjKAlElFsNz2scWFWRe49NHlj9qaq/yWZ8Cn0IeHy8j8F+jMek4zt\ndCSxVEayVG/k8RFmYCcluQc/1LuCjPiFwJU43AGkO+yvmOuYGivsNKY+54yuEZqF\nVDsjAjMsYXxgLx9y1F7Rq3CfeqY6IajR7pmmRup8/D9NyyyQuIML83mjTSvo0UYu\nrkdXPObd/m6gumscvXMl6SoJ5IPItvTA42MZqTaNzimF0QIDAQABo2gwZjBkBgNV\nHREEXTBbgglsb2NhbGhvc3SCBmNvbmp1coIcY29uanVyLW1hc3Rlci5pdHAuY29u\nanVyLm5ldIIoZWMyLTU0LTkxLTI0Ni04NC5jb21wdXRlLTEuYW1hem9uYXdzLmNv\nbTANBgkqhkiG9w0BAQUFAAOCAQEANk7P3ZEZHLgiTrLG13VAkm33FAvFzRG6akx1\njgNeRDgSaxRtrfJq3mnhsmD6hdvv+e6prPCFOjeEDheyCZyQDESdVEJBwytHVjnH\ndbvgMRaPm6OO8CyRyNjg3YcC36T//oQKOdAXXEcrtd0QbelBDYlKA7smJtznfhAb\nXypVdeS/6I4qvJi3Ckp5sQ1GszYhVXAvEeWeY59WwsTWYHLkzss9QShnigPyo3LY\nZA5JVXofYi9DJ6VexP7sJNhCMrY2WnMpPcAOB9T7a6lcoXj6mWxvFys0xDIEOnc6\nNGb+d47blphUKRZMAUZgYgFfMfmlyu1IXj03J8AuKtIMEwkXAA==\n-----END CERTIFICATE-----\n"

default['jenkins']['plugins'] = [
  "git",
  "git-client",
  "github",
  { "ruby-runtime" => { version: "0.12" } },
  "rvm"
]

default['rvm']['installs'] = {
  'jenkins' => true
}
