require 'dry-struct'

module Ldap

  module Types
    include Dry::Types.module
  end

  class LogEntry < Dry::Struct
    # can type these more accurately later, if need arises
    attribute :timestamp, Types::Strict::String
    attribute :severity , Types::Strict::String
    attribute :message  , Types::Strict::String
  end

end
