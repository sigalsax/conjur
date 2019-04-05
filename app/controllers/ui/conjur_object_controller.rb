# The +ConjurObjectController controller handles most of the functionality
# required for the `index` and `show` actions. Controller naming is important.
# The resource type is introspected from the controller name, so `HostsController`
# would result use the resource `:host`.

class Ui::ConjurObjectController < Ui::ApplicationController
  before_action :find_conjur_object, only: [:show, :audit_events, :audit_warnings, :audit_updates]
  before_action :verify_object_visibility, only: [:show]
  # helper ResourceHelper
  include ResourceHelper

  def show;end

  def index
    page = params[:page].to_i
    search = params[:search].to_s
    limit = (page + 1) * 20

    options = {
        limit: limit,
        offset: 0,
        search: search
    }.delete_if { |_, v| v.to_s.empty? }

    resource_list_items = load_resources(options).map do |resource|
      helpers.format_resource_list_item(resource)
    end
    more = more_resources?(options.merge(limit: 1, offset: limit + 1))
    less = page > 0

    resource_list = {
        kind: title.downcase,
        resource_list_items: resource_list_items,
        more: more,
        more_path: resource_list_path(page: page+1, search: search),
        less: less,
        less_path: resource_list_path(page: page-1, search: search),
        search: search
    }

    respond_to do |format|
      format.js {
        render partial: 'resource_list', locals: {
            page: page,
            resource_list: resource_list
        }
      }
      format.html {
        render 'index', locals: {
            title: title,
            resource_list_path: resource_list_path,
            resource_list: resource_list,
            search: search
        }
      }
      format.all {
        raise ActionController::RoutingError.new('Not Found')
      }
    end
  end

  def resource_list_path(opt={})
    send("#{kind.to_s.pluralize}_path", opt)
  end

  def audit_events
    audit_events = @conjur_object.audit_events(search_options[:limit])

    render partial: "audit_events_table", object: audit_events
  end

  def audit_warnings
    audit_warnings = @conjur_object.audit_warnings(search_options[:limit])

    render partial: "audit_warnings_table", object: audit_warnings
  end

  def audit_updates
    audit_updates = @conjur_object.audit_updates(search_options[:limit])

    render partial: "audit_updates_table", object: audit_updates
  end

  protected

  def title
    kind.to_s.titleize.pluralize
  end

  def kind
    self.class.to_s.underscore.split('_')[0].singularize.to_sym
  end

  def load_resources(args = {})
    params = { kind: kind }.merge(args)
    api.resources(params).map do |resource|
      GenericResource.new(resource)
    end
  end

  def more_resources?(args = {})
    !load_resources(args).empty?
  end

  # Verify that the authenticated user has some privilege on +@conjur_object@+.
  def verify_object_visibility
    raise NotFoundError unless @conjur_object
    raise ForbiddenError unless @conjur_object.conjur_resource.permitted?('read')
  end

  def decoded_id
    params[:id].gsub('%2E', '.').gsub('%2F', '/')
  end

  def search_options
    {
      limit: (params[:limit] || 10).to_i
    }.tap do |options|
      options[:search] = params[:search] if params.key?(:search)
    end
  end

  def find_conjur_object
    kind = controller_name.classify.downcase
    @conjur_object = controller_name.classify.constantize.new(api.build_object([Conjur.configuration.account, kind, decoded_id]))
    instance_variable_set("@#{kind}", @conjur_object)
    @conjur_role = @conjur_object.conjur_role if @conjur_object.respond_to?(:roleid)
  end

end
