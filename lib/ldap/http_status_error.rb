module Ldap

  class HttpStatusError < RuntimeError
    def initialize(response_error)
      msg = JSON.parse(response_error.response)['error']['message']
      msg ? super(msg) : super(response_error.inspect)
    rescue => e
      raise UnexpectedServerResponse, "Response body couldn't be parsed: #{e}"
    end
  end

end
