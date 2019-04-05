require "ldap/policy_generator"

class Ui::Ldap::SavedUsersController < ApplicationController
  include Ldap::LdapHelper

  def update
    save_selected_users
    redirect_to(ldap_import_instructions_path)
  rescue => e
    flash[:error_message] = e.message
    redirect_to(edit_ldap_selected_users_path)
  end

  # Override ApplicationController::clear_conjur_cache
  # This prevents the cache from being cleared after every API call during LDAP
  # sync configuration. We need to hold on to the LDAP certificate written after
  # the initial connection in order to use it in subsequent steps.
  def clear_conjur_cache
    true
  end

  private

  def save_selected_users
    ldap_config = ldap_sync_config_param

    if (password = ldap_config.delete(:bind_password))
      save_password(configuration_name, password)
    end

    save_tls_ca_cert(configuration_name, cached_tls_cert)

    api.load_policy policy_load_location,
                    ldap_policy_patch(configuration_name, ldap_config),
                    method: Conjur::API::POLICY_METHOD_PATCH
  end

  def save_password(configuration_name, password)
    variable_name = [policy_load_location, "bind-password", configuration_name].join("/")
    variable_id = [Conjur.configuration.account, "variable", variable_name].join(":")
    api.resource(variable_id).add_value password
  end

  def save_tls_ca_cert(configuration_name, tls_ca_cert)
    return unless tls_ca_cert.present?

    variable_name = [policy_load_location, "tls-ca-cert", configuration_name].join("/")
    variable_id = [Conjur.configuration.account, "variable", variable_name].join(":")
    variable = api.resource(variable_id)

    raise NotFoundError, "Failed to save certificate: #{variable_id} does not exist" unless variable.exists?

    variable.add_value tls_ca_cert
  end

  def ldap_policy_patch(configuration_name, ldap_config)
    [Ldap::PolicyGenerator::TaggedValue.new(
      "!resource",
      "id" => configuration_name,
      "owner" => Ldap::PolicyGenerator::TaggedValue.new("!host", ""),
      "kind" => "configuration",
      "annotations" => ldap_sync_config_annotations(ldap_config)
    )].to_yaml
  end

  def ldap_sync_config_annotations(ldap_config)
    flatten(ldap_config)
      .map { |key, value| ["#{annotation_prefix}#{key}", value] }
      .to_h
  end

  def ldap_sync_config_param
    saved_selected_users_form.payload[:config]
  end

  def policy_load_location
    "conjur/ldap-sync"
  end

  def configuration_name
    "default"
  end

  def annotation_prefix
    "ldap-sync/"
  end
end
