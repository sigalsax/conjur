module ViewIdHelper
  def pretty_view(id, kind = nil)
    id = "#{kind}:#{id}" if kind
    r = api.role(id)
    "#{r.kind}:#{r.identifier}"
  end

  def resource_id_path(id)
    _,kind,id = id.split(':', 3)
    if url_helpers.respond_to?( path = "#{kind}_path" )
      url_helpers.send(path, URI.encode_www_form_component(id))
    else
      ''
    end
  end

  def resource_id_link(id)
    _,object_type,title = id.split(':', 3)

    escaped_title = CGI.escape(title).gsub(/\./, '%2E').gsub(/\//, '%2F')
    if url_helpers.respond_to?( path = "#{object_type}_path" )
      path = url_helpers.send(path, escaped_title)
      link_to(title, path)
    else
      title
    end

  end

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
