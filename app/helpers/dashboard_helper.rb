module DashboardHelper

  def inline_width(proper_fraction)
    percent = 100 * proper_fraction
    "width: #{percent}%"
  end

  def render_audit_events(limit)
    limit ||= 15
    events = get_audit_events({limit: limit})
    show_more_path = events.count < limit ? nil : dashboard_audit_events_path(limit: limit + 5)
    audit_table_with_pagination("audit-events", events, show_more_path)
  end

  def render_audit_warnings(limit)
    limit ||= 5
    events = get_audit_warnings(limit)
    show_more_path = events.count < limit ? nil : dashboard_audit_warnings_path(limit: limit + 5)
    audit_table_with_pagination("audit-warnings", events, show_more_path,'warnings')
  end

  def render_audit_changes(limit)
    limit ||= 5
    events = get_audit_changes(limit)
    show_more_path = events.count < limit ? nil : dashboard_audit_changes_path(limit: limit + 5)
    audit_table_with_pagination("audit-changes", events, show_more_path,  'recent permission model changes')
  end

  private

  def audit_table_with_pagination(id, events, show_more_path, label = nil)
    render_to_string(partial: "audit_table", object: events, locals: {label: label}) + show_more(show_more_path)
  end

  def show_more(show_more_path)
    show_more_path ? render_to_string(partial: "show_more", locals: {show_more_path: show_more_path}) : ''
  end

  def get_audit_warnings(limit)
    filter_events(limit, :warning?)
  end

  def get_audit_changes(limit)
    filter_events(limit, :permission_change?)
  end

  def get_audit_events(options = {})
    def options.slice(*rest)
      self
    end

    if Conjur.v5?
      req = api.url_for(:audit_events, api.credentials, options)
      JSON.parse(req.get.body).map(&Audit.method(:new))
    else
      Rails.cache.fetch "audit/#{@current_user}/#{options}", expire: 1.minute do
        api.audit(options).reverse.map do |audit|
          Audit.new audit
        end
      end
    end
  end

  protected

  def filter_events(limit = 15, filter_method)
    get_audit_events({limit: 500})
        .select do |event|
      event.send(filter_method)
    end.take(limit)
  end

end
