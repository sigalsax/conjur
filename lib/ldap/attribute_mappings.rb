require 'dry-struct'

module Ldap

  module Types
    include Dry::Types.module
  end

  class AttributeMappings < Dry::Struct

    attribute :group_name, Types::Strict::String
    attribute :gid       , Types::Strict::String
    attribute :user_name , Types::Strict::String
    attribute :public_key, Types::Strict::String
    attribute :uid       , Types::Strict::String

    attr_reader :group_attribute_mapping, :user_attribute_mapping

    def initialize(**args)
      super(args)
      @group_attribute_mapping = remove_blank({name: group_name, gid: gid})
      @user_attribute_mapping  = remove_blank({
        name: user_name, uid: uid, public_key: public_key})
    end

    def self.blank
      new(group_name: '', gid: '', user_name: '', public_key: '', uid: '')
    end
    
    private

    def remove_blank(hash)
      hash.select { |_, v| !v.blank? }
    end
  end

end
