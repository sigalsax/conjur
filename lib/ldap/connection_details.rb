require 'dry-struct'

module Ldap

  module Types
    include Dry::Types.module
  end

  class ConnectionDetails < Dry::Struct

    attribute :base_dn      , Types::Strict::String
    attribute :bind_dn      , Types::Strict::String
    attribute :bind_password, Types::Strict::String
    attribute :connect_type , Types::Strict::String
    attribute :tls_cert     , Types::Strict::String
    attribute :host         , Types::Strict::String
    attribute :port         , Types::Coercible::Int

    def self.blank
      new(
        base_dn: '', bind_dn: '', bind_password: '', connect_type: 'plain',
        tls_cert: '', host: '', port: 389
      )
    end

    def secure?
      ['ssl', 'tls'].include?(connect_type)
    end

    # because ldap-sync service doesn't allow blank tls
    def inputs
      to_h.reject { |k, v| k == :tls_cert && v.empty? }
    end

    def payload
      {config: inputs}
    end
  end

end
