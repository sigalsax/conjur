require 'json'
require 'active_support/core_ext/hash'

module Ldap

  class SearchError < RuntimeError
    attr_reader :log_entries

    def initialize(log_entries)
      super('LDAP search responded with a failure message')
      @log_entries = log_entries
    end

    def to_json
      log_entries.map(&:to_h).to_json
    end

    def self.from_json(json)
      entries = JSON.parse(json).map { |x| LogEntry.new(x.symbolize_keys) }
      new(entries)
    end
  end

end
