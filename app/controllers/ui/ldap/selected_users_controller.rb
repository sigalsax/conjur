class Ui::Ldap::SelectedUsersController < ApplicationController

  include Ldap::LdapHelper

  before_action :ensure_connection_details_complete!
  before_action :ensure_selected_users_complete!, only: [:show]

  def edit
    @error_message = flash[:error_message]
    @search_error = saved_search_error
    @selected_users_form = saved_selected_users_form
  end

  def update
    search_and_cache
    remember_users_inputs
    redirect_to(ldap_selected_users_path)
  rescue Ldap::SearchError => e
    flash[:search_error] = e.to_json
    redirect_with_error(e)
  rescue => e
    redirect_with_error(e)
  end

  def show
    @selected_users_form = saved_selected_users_form
    @selected_users = cached_search_results
  end

  # Override ApplicationController::clear_conjur_cache
  # This prevents the cache from being cleared after every API call during LDAP
  # sync configuration. We need to hold on to the LDAP certificate written after
  # the initial connection in order to use it in subsequent steps.
  def clear_conjur_cache
    true
  end

  private

  # store results on local file system for redirect
  def search_and_cache
    Rails.cache.fetch('ldap-sync/last-search', expires_in: 5.minutes, force: true) do
      ldap_sync_api.search(search_inputs(params))
    end
  end

  def cached_search_results
    Rails.cache.fetch('ldap-sync/last-search') do
      ldap_sync_api.search(saved_selected_users_form)
    end
  end

  def saved_search_error
    flash[:search_error] && Ldap::SearchError.from_json(flash[:search_error])
  end

  def redirect_with_error(e)
    flash[:error_message] = e.message
    flash[:selected_users_params] = params.as_json
    redirect_to(edit_ldap_selected_users_path)
  end

  def remember_users_inputs
    session[:selected_users_params] = params.as_json
  end

  def ensure_connection_details_complete!
    incomplete = session[:connection_details].nil?
    redirect_to(edit_ldap_connection_details_path) if incomplete
  end

  def ensure_selected_users_complete!
    incomplete = session[:selected_users_params].nil?
    redirect_to(edit_ldap_selected_users_path) if incomplete
  end

end
