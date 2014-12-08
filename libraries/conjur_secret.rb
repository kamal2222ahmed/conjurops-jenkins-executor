module ConjurSecret
  def conjur_secret(id)
    conjur_api.variable(id).value
  end
  
  def conjur_api
    require 'conjur/authn'
    Conjur::Authn.connect
  end
end

class Chef::Resource
  include ConjurSecret
end
