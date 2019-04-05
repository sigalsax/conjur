require 'dry-struct'

module Ldap

  module Types
    include Dry::Types.module
  end

  class SearchInputs < Dry::Struct

    extend Forwardable

    attribute :connection_details, Types.Instance(ConnectionDetails)
    attribute :group_filter      , Types::Strict::String
    attribute :user_filter       , Types::Strict::String
    attribute :attribute_mappings, Types.Instance(AttributeMappings)

    def_delegators :attribute_mappings, :group_name, :gid, :user_name,
                   :public_key, :uid

    def initialize(**args)

      super(args)
      group_mapping = attribute_mappings.group_attribute_mapping
      user_mapping = attribute_mappings.user_attribute_mapping

      search_inputs = {
        group_attribute_mapping: group_mapping,
        user_attribute_mapping:  user_mapping,
        group_filter:            group_filter,
        user_filter:             user_filter,
        import_gid_numbers:      group_mapping.has_key?(:gid),
        import_public_keys:      user_mapping.has_key?(:public_key),
        import_uid_numbers:      user_mapping.has_key?(:uid)
      }
      @inputs = connection_details.inputs.merge(search_inputs)
    end

    # even though it's "blank", we already have the connection_details 
    # at this step, so we force that as a parameter
    def self.blank(connection_details)
      new(
        connection_details: connection_details, group_filter: '',
        user_filter: '', attribute_mappings: AttributeMappings.blank
      )
    end

    def payload
      {config: @inputs}
    end
  end

end
