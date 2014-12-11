module ConjurSecret
  def conjur_secret(id)
    conjur_api.variable(id).value
  end

  def conjur_api
    require 'conjur/authn'
    require 'conjur/config'
    Conjur::Config.load [ '/etc/conjur.conf' ]
    Conjur::Config.apply
    Conjur::Authn.connect nil, noask: true
  end
end

class Chef::Resource
  include ConjurSecret
end
