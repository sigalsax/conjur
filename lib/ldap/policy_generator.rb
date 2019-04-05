# -*- encoding : utf-8 -*-
require 'yaml'
require 'psych'
require 'active_support/core_ext/hash/keys'

module Ldap
  module PolicyGenerator
    # This class represents a tagged yaml object.  It can have
    # as its contents any yaml value.
    class TaggedValue

      attr_reader :tag,:value

      def initialize tag, value
        @tag = tag
        @value = value
      end

      def encode_with coder
        case value
          when Hash then coder.represent_map tag, value.stringify_keys
          when String, Symbol then coder.represent_scalar tag, value.to_s
          when Numeric then coder.represent_scalar tag, value
          else raise "don't know how to encode tagged value #{tag}:#{value.class}"
        end
      end

      def to_s
        "<#{tag} #{value}>"
      end

    end
  end
end
