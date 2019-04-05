class Ui::ListController < Ui::ApplicationController
  before_action :populate_requested
  before_action :populate_role, except: [:audit_events, :warnings ]
  before_action :populate_user, only: [ :audit_events, :warnings]
  before_action :populate_search

  def members
    options = search_options
    options.merge!(kind: 'policy') if @conjur_object.kind == "policy"
    members = @conjur_object.members options
    resource = @conjur_object.kind.classify.constantize.new(api.resource(@conjur_object.roleid))
    render partial: "members_table", object: members, locals: { editable: resource.try(:editable?), container: resource}
  end

  def memberships
    case @conjur_object.kind.to_sym
      when :host
        partial = 'layers_memberships_table'
        options = search_options.merge({ kind: 'layer' })
      else
        partial = 'memberships_table'
        options = search_options
    end

    render partial: partial, object: @conjur_object.memberships(options)
  end

  def privileges
    permissions = @conjur_object.permissions search_options

    render partial: "privileges_table", object: permissions
  end

  def warnings
    warnings = @conjur_object.warnings search_options[:limit]

    render partial: "audit_event_warnings_table", object: warnings
  end

  def audit_events
    audit_events = @conjur_object.audit_events search_options[:limit]

    render partial: "audit_events_table", object: audit_events
  end


  protected

  def search_options
    {
      limit: @requested
    }.tap do |options|
      options[:search] = @search if @search
    end
  end

  def populate_requested
    @requested = (params[:limit] || 10).to_i
  end

  def populate_role
    role  = params[:role]
    @conjur_role = api.role(role)
    @conjur_object = GenericRole.new(@conjur_role)
  end

  def populate_host
    role  = params[:role]
    @host = api.role(role)
    @conjur_object = Host.new(@host)
    @conjur_role = @conjur_object.conjur_role
  end

  def populate_user
    role  = params[:role]
    user = api.role(role)
    @conjur_object = User.new(user)
    @conjur_role = @conjur_object.conjur_role
  end

  def populate_search
    @search = params[:search]
    true
  end
end
