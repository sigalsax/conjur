require 'rest-client'
require 'json'

module Ldap

  class LdapSyncApi

    attr_reader :rest_client

    def initialize(auth_token, rest_client: RestClient)
      @rest_client = rest_client
      @base64_token = base64_token(auth_token)
    end

    # we don't care about the results of connect
    # we simply want to know if it succeeds or not
    #
    def connect(connection_details)
      rest_client.post(
        "#{base_url}/ldap-sync/connect",
        connection_details.payload.to_json,
        headers
      )
    rescue rest_client::ExceptionWithResponse => e
      raise HttpStatusError, e
    rescue => e
      raise UnexpectedServerResponse, e
    end

    def search(search_inputs)
      resp = rest_client.post(
        "#{base_url}/ldap-sync/search",
        search_inputs.payload.to_json,
        headers
      )
      SearchResults.new(resp).tap do |result|
        raise SearchError.new(result.log_entries) unless result.success?
      end
    rescue SearchError => e
      raise e
    rescue rest_client::ExceptionWithResponse => e
      raise HttpStatusError, e
    rescue => e
      raise UnexpectedServerResponse, e
    end

    private

    def headers
      {
        Authorization: "Token token=\"#{@base64_token}\"",
        content_type: :json,
        accept: :json
      }
    end

    def base64_token(token)
      # "strict" is required here to avoid insertion of newlines
      Base64.strict_encode64(token.to_json).chomp
    end

    def base_url
      Conjur.configuration.appliance_url
    end

  end

end
