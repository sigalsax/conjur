module Ldap

  # Network failures, response parsing errors
  # Anything that's *not* a complete error response
  # coming from the server
  #
  class UnexpectedServerResponse < RuntimeError
  end
end
