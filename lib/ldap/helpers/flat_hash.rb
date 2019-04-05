# -*- encoding : utf-8 -*-
module Ldap
  module Helpers
    module FlatHash
      def self.included base
        base.extend self
      end

      SEPARATOR = '/'

      # Takes a "deep" hash and flattens it by replacing nested paths with
      # "key1.key2" syntax.
      #
      # @param [Hash, Array] hash_or_array
      # @return [Hash] a 'flat' hash
      def flatten hash_or_array
        ({}).tap do |result|
          case hash_or_array
            when Array then
              flatten_array(hash_or_array, nil, result)
            when Hash then
              flatten_hash(hash_or_array, nil, result)
            else
              raise "flatten argument must be Array or Hash (was #{hash_or_array.class.name})"
          end
        end
      end

      private

      def flatten_array array, prefix, result
        array.each_with_index do |value, index|
          path = [prefix, index.to_s].compact.join(SEPARATOR)
          case value
            when Array then
              flatten_array(value, path, result)
            when Hash then
              flatten_hash(value, path, result)
            else
              result[path] = value
          end
        end
      end

      def flatten_hash hash, prefix, result
        hash.each do |key, value|
          path = [prefix, key].compact.join(SEPARATOR)
          case value
            when Array then
              flatten_array(value, path, result)
            when Hash then
              flatten_hash(value, path, result)
            else
              result[path] = value
          end
        end
      end
    end
  end
end
