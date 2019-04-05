require 'active_support/core_ext/hash'

module Ldap

  class SearchResults
    attr_reader :log_entries, :users, :groups

    def initialize(resp)
      results = JSON.parse(resp)
      @success = results['ok']
      @users = to_ldap_entries(results['users']) if @success
      @groups = to_ldap_entries(results['groups']) if @success
      @log_entries = to_log_entries(remove_dups(results['events']))
    end

    def success?
      @success
    end

    private

    def remove_dups(entries)
      entries.uniq {|entry| entry['severity'] + entry['message']}
    end

    def to_ldap_entries(results)
      results.map {|result| LdapEntry.new(result['name'])}
    end

    def to_log_entries(raw_entries)
      raw_entries.map do |entry|
        LogEntry.new(entry.symbolize_keys)
      end
    end

    # Don't think we need this, after fixing ldap-sync to work properly
    #
    # def all_sse_chunks(resp)
    #   # because ldap-sync sends the old SSE format as "json" (air quotes),
    #   # response comes as a series of chunks prepended with 'data: '.  Since each
    #   # chunk *is* proper json once the 'data: ' prefix is removed, we parse them
    #   # individually, transforming the response to an array of log lines and the
    #   # main users & groups response.

    #   resp.split(/\n+/).map do |chunk|
    #     JSON.parse(chunk.sub(/^data: /, ''))
    #   end
    # end

  end
end
