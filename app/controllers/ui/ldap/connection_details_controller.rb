class Ui::Ldap::ConnectionDetailsController < ApplicationController

  include Ldap::LdapHelper

  before_action :validate_user_ldap_input, only: [:update]

  def edit
    @error_message = flash[:error_message]
    @connection_details = saved_connection_details
  end

  def update
    test_connection
    remember_users_inputs
    redirect_to(edit_ldap_selected_users_path)
  rescue => e
    set_error(e.message)
    redirect_to_edit
  end

  # Override ApplicationController::clear_conjur_cache
  # This prevents the cache from being cleared after every API call during LDAP
  # sync configuration. We need to hold on to the LDAP certificate written after
  # the initial connection in order to use it in subsequent steps.
  def clear_conjur_cache
    true
  end

  private

  def validate_user_ldap_input
    error_message = "Submitted invalid or empty parameter(s):"
    param_validator_fails = false

    if params[:port].blank? || params[:port].to_i < 1 || params[:port].to_i > 65535
      params[:port] = 389
      error_message.concat(" - Port")
      param_validator_fails = true
    end
    if params[:host].blank?
      error_message.concat(" - Server")
      param_validator_fails = true
    end
    if params[:base_dn].blank?
      error_message.concat(" - Base DN")
      param_validator_fails = true
    end
    if params[:bind_dn].blank?
      error_message.concat(" - Bind DN")
      param_validator_fails = true
    end
    if params[:bind_password].blank?
      error_message.concat(" - Search Password")
      param_validator_fails = true
    end

    if param_validator_fails
      set_error(error_message)
      redirect_to_edit
    end
  end

  def saved_connection_details
    # saved_inputs - utility defined in ApplicationController
    # tls_cert is too big for session, so was stored in rails cache
    saved = saved_inputs(:connection_details)
    saved = saved.merge(tls_cert: cached_tls_cert) if saved
    saved ? Ldap::ConnectionDetails.new(saved.to_h.symbolize_keys)
          : Ldap::ConnectionDetails.blank
  end

  def submitted_connection_details
    Ldap::ConnectionDetails.new(params.to_h.symbolize_keys)
  end

  def test_connection
    ldap_sync_api.connect(submitted_connection_details)
  end

  def remember_users_inputs
    details = submitted_connection_details

    # tls_cert is too big to fit in a cookie, so we remove it
    session[:connection_details] = details.to_h.merge(tls_cert: '')

    # and cache its value separately
    cache_tls_cert(details.tls_cert)
  end

  # use Rails cache for cert, otherwise it overflows the cookie
  def cache_tls_cert(cert)
    # dirty fix: This should track the session itself, not be 1 hour
    Rails.cache.fetch('ldap-sync/tls_cert', expires_in: 1.hour, force: true) do
      cert
    end
  end

  def set_error(error_message)
    flash[:error_message] = error_message
  end

  def redirect_to_edit
    # tls_cert is too big to fit in a cookie, so we remove and store in cache
    flash[:connection_details] = params.merge(tls_cert: '') # redisplay user input
    cache_tls_cert(params[:tls_cert])

    redirect_to(edit_ldap_connection_details_path)
  end

end
