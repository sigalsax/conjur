class Ui::DashboardController < Ui::ApplicationController
  include DashboardHelper

  def index
    @resources_stats = resources_stats
    @most_active_secrets = MostActiveSecretsDecorator.new(
      # TODO: &:symbolize_keys should be inside most_active_secrets
      #       but something weird is happening with rails cache
      most_active_secrets.map(&:symbolize_keys)
    )
    @dashboard_stats = dashboard_stats
    @current_user = current_user
  end

  def audit_events
    render html: render_audit_events(audit_limit)
  end

  def audit_warnings
    render html: render_audit_warnings(audit_limit)
  end

  def audit_changes
    render html: render_audit_changes(audit_limit)
  end

  private

  def audit_limit
    limit = params[:limit].to_i
    limit > 0 ? limit : nil
  end

  DASHBOARD_EXPIRY = 5.minutes

  def resources_stats
    if Conjur.v5?
      kinds = %w[group host layer user variable webservice]

      # Retrieve each resource count in parallel
      Parallel.map(kinds) { |kind| [kind, {total: api.resources(kind: kind, count: true)}]}
              .to_h
    else
      Rails.cache.fetch 'resources_stats', expire: DASHBOARD_EXPIRY do
        JSON.parse RestClient.get('localhost/uiapi/resources_stats').body
      end
    end
  end

  def most_active_secrets
    if Conjur.v5?
      {}
    else
      Rails.cache.fetch 'most_active_secrets', expire: DASHBOARD_EXPIRY do
        JSON.parse RestClient.get('localhost/uiapi/most_active_secrets').body
      end
    end
  end

  def dashboard_stats
    if Conjur.v5?
      {}
    else
      Rails.cache.fetch 'dashboard_stats', expire: DASHBOARD_EXPIRY do
        JSON.parse RestClient.get('localhost/uiapi/dashboard_stats').body
      end
    end
  end

  def current_user
    session[:conjur_username]
  end

end
