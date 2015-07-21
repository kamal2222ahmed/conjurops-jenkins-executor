name "development"

appliance_hostname = 'ec2-54-90-21-213.compute-1.amazonaws.com'
override_attributes(
  "conjur" => {
    "configuration" => {
      "account" => 'ci',
      "appliance_url" => "https://#{appliance_hostname}/api",
      "ssl_certificate" => "-----BEGIN CERTIFICATE-----\nMIIDkDCCAnigAwIBAgIJAJ4Ta9QNsNa6MA0GCSqGSIb3DQEBBQUAMDMxMTAvBgNV\nBAMTKGVjMi01NC05MC0yMS0yMTMuY29tcHV0ZS0xLmFtYXpvbmF3cy5jb20wHhcN\nMTUwNjE5MTgxMTU5WhcNMjUwNjE2MTgxMTU5WjAzMTEwLwYDVQQDEyhlYzItNTQt\nOTAtMjEtMjEzLmNvbXB1dGUtMS5hbWF6b25hd3MuY29tMIIBIjANBgkqhkiG9w0B\nAQEFAAOCAQ8AMIIBCgKCAQEAw1pKG3Azpw7ILWk83kno+C+husSBRyxJg2JJMKhv\nNEoqMeCuRGiAduksqMg2J44ONTzN0nkDMTwxqcc7OY8EEPl57hf29MDjWJgdJsuu\nChu0KcNMNedgFE+qVozj7iZiERvICDMNkQSuVlMoJukVwGG3mnYUrqpW5FR5Atp7\nmLlUlVIqho076ZRSwglfsSqOy1geRGEXMthFEB9ZEzAtf2ygfmMk5BxogMNN+Xwu\ne8uLsqfVx/crRDLj5Wx3+v5qyKnE1qJ2+25YfvmsDBHlp8Pf5rXMMaTx4I1nuE9j\nBVpXq6OQ0g54dg/eFGKlm1tIe2fg7hybpSiMUGved8XCDwIDAQABo4GmMIGjMEYG\nA1UdEQQ/MD2CCWxvY2FsaG9zdIIGY29uanVygihlYzItNTQtOTAtMjEtMjEzLmNv\nbXB1dGUtMS5hbWF6b25hd3MuY29tMB0GA1UdDgQWBBRooddhAlwCYPEivR2FNscw\nfDn7WDAfBgNVHSMEGDAWgBRooddhAlwCYPEivR2FNscwfDn7WDAMBgNVHRMEBTAD\nAQH/MAsGA1UdDwQEAwIB5jANBgkqhkiG9w0BAQUFAAOCAQEAbyPTihOXBe9YYWl4\ndAiWE2RguceEnSeLBl6aWsuWzVLaPMPh8Yzin1vHO9nuRm1bIcPvApgtmtqWm492\nMiEZt4N6vSdkqfiVBAbMr8ZcPKqIJW1RdRchrnNWVSp1T+UHal132Htbb+0DDWMT\nvOU3ZrI6FGNaqbfWJjzq4Q1hSkmEAZcbc1+3MxqceAP6fa7YqbIdq1TwKW/QVC+r\nnx2htKe/wkW3iJvRe0lFgFoAzO3RBcXlJ6SoX7EZcGU49y6kli6/LrR3U/U6Oqnt\nbwzMU/C/M6tLRva+A/m16oeF39p14kxG1XIQRtm21/koA+5FZUnGUJfPkDIJDkP1\ni1Su/Q==\n-----END CERTIFICATE-----"
    }
  },
  "docker-registry" => {
    'appliance-url' => "https://#{appliance_hostname}/api/authn"
  }
)

