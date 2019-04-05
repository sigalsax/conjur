module ConjurAPI
  def conjur_api
    Thread.current[:conjur_api] or raise "No Conjur API for current thread"
  end

  def expose_conjur_api &block
    ConjurAPI.expose_conjur_api api, &block
  end

  def self.expose_conjur_api api, &block
    Thread.current[:conjur_api] = api
    begin
      yield
    ensure
      Thread.current[:conjur_api] = nil
    end
  end
end
