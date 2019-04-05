require "ldap/helpers/flat_hash"

module Ldap::LdapHelper

  include Ldap::Helpers::FlatHash

  def ldap_sync_api
    Ldap::LdapSyncApi.new(conjur_api_token)
  end

  def search_inputs(params_)
    params_ = params_.to_h.symbolize_keys
    Ldap::SearchInputs.new(
      connection_details: connection_details,
      group_filter: params_[:group_filter],
      user_filter: params_[:user_filter],
      attribute_mappings: Ldap::AttributeMappings.new(params_)
    )
  end

  def saved_selected_users_form
    saved = saved_inputs(:selected_users_params)
    saved ? search_inputs(saved)
          : Ldap::SearchInputs.blank(connection_details)
  end

  def connection_details
    Ldap::ConnectionDetails.new(
      session[:connection_details].symbolize_keys.merge(
        tls_cert: cached_tls_cert
      )
    )
  end

  def cached_tls_cert
    Rails.cache.fetch('ldap-sync/tls_cert') { '' }
  end

end
