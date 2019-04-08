class Ui::ApplicationController < ActionController::Base
  include ConjurAPI
  # include ActionController::Helpers

  DEFAULT_SESSION_TIMEOUT = 15 # Minutes

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :navigation_menu
  # around_action :expose_conjur_api
  before_action :clear_conjur_cache

  helper_attr :api

  rescue_from ForbiddenError, with: :forbidden
  rescue_from NotFoundError, with: :not_found
  rescue_from RestClient::Unauthorized, with: :redirect_to_login

  def api
    @api ||= Conjur::API.new_from_key(
          session[:conjur_username],
          session[:conjur_api_key]
        )
  rescue RestClient::Unauthorized
    redirect_to_login('')
  end

  def conjur_api_token
    Conjur::API.authenticate(
      session[:conjur_username],
      session[:conjur_api_key]
    )
  end

  def redirect_to_login msg = ''
    if msg.is_a?(Exception)
      msg = 'Your session is expired'
    end
    clear_session(authorization_session_keys)
    flash[:notice] = msg if msg.present?
    redirect_to new_login_path
    return false
  end

  def authenticated?
    !(session_blank?(authorization_session_keys) || session_expired?)
  end

  def session_expired?
    session[:expires_at] < DateTime.now
  end

  def authenticate_user!
    if authenticated?
      session[:expires_at] = ApplicationController.expires_at.from_now
    else
      redirect_to_login('')
    end
  end

  def authorization_session_keys
    [:conjur_username, :conjur_api_key, :expires_at]
  end

  def session_blank?(keys)
    keys.any? { |key| session[key].blank? }
  end

  # Helper for post-redirect-get pattern:
  # First checks the flash, so the user's error-causing input is not
  # overwritten by previously saved successful input.  Then checks
  # session for previously saved successful input.
  def saved_inputs(resource_name)
    flash[resource_name] || session[resource_name] || nil
  end

  def clear_session(keys)
    keys.each { |key| session[key] = nil }
  end

  def self.expires_at
    timeout = ENV["UI_SESSION_TIMEOUT"].to_i # If invalid, the value will be 0
    (timeout > 0 ? timeout : DEFAULT_SESSION_TIMEOUT).minutes
  end

  def expose_conjur_api &block
    return yield unless authenticated?

    super
  end

  # Fetch the most recent audit record. See if any updates have been
  # written since the last time the cache was cleared.
  def clear_conjur_cache
    return true unless authenticated?

    if Conjur.v5?
      # XXX Clear the ConjurCache on every request, until audit is available
      ConjurCache.clear
    else
      audit_update = conjur_api.audit_updates(ConjurCache.last_message_id)

      Rails.logger.debug "Audit update : #{audit_update}"

      if audit_update['update_count'] > 0
        Rails.logger.info "Clearing cache on message id #{audit_update['message_id']}"
        ConjurCache.clear
      end

      ConjurCache.last_message_id = audit_update['message_id']
    end

    true
  end

  protected

  def forbidden exception
    logger.debug "#{exception}\n#{exception.backtrace.join "\n"}"

    head :forbidden
  end

  def not_found exception
    logger.debug "#{exception}\n#{exception.backtrace.join "\n"}"

    head :not_found
  end

  protected

  UI_PREFIX = '/ui'
  NEW_UI_PREFIX = '/ui'

  def navigation_menu
    @navigation_menu = [
      {title: 'Dashboard', path: "#{UI_PREFIX}/dashboard", icon: 'dashboard'},
      {title: 'Policies', path: "#{NEW_UI_PREFIX}/policies", icon: 'policy'},
      {title: 'Hosts', path: "#{NEW_UI_PREFIX}/hosts", icon: 'host'},
      {title: 'Layers', path: "#{NEW_UI_PREFIX}/layers", icon: 'layer'},
      {title: 'Users', path: "#{NEW_UI_PREFIX}/users", icon: 'user'},
      {title: 'Groups', path: "#{NEW_UI_PREFIX}/groups", icon: 'group'},
      {title: 'Secrets', path: "#{NEW_UI_PREFIX}/secrets", icon: 'variable'},
      {title: 'Webservices', path: "#{NEW_UI_PREFIX}/webservices", icon: 'webservice'},
    ]
  end
end
