module ConjurSecret
  def conjur_secret(id)
    conjur_api.variable(id).value
  end

  def conjur_pubkeys(username)
    conjur_api.public_keys(username)
  end

  def conjur_api
    require 'conjur/authn'
    require 'conjur/config'
    Conjur::Config.load
    Conjur::Config.apply
    Conjur::Authn.connect nil, noask: true
  end
end

class Chef::Resource
  include ConjurSecret
end
