# frozen_string_literal: true

module ResourceHelper
  def format_resource_list_item(resource)
    {
      resource: format_resource(resource),
      owner: format_resource(resource.owner),
      integrations: resource.integrations.sort.to_h.keys.map do |name|
                      { name: name.to_s, label: name.to_s.humanize }
                    end
    }
  end

  def format_resource(resource)
    if resource.is_a?(String)
      resource = ConjurDummyObject.new(*resource.split(":", 3))
    end

    {
      name: resource.id,
      with_rotator: resource.with_rotator?,
      kind: resource.kind,
      url: resource_url(resource)
    }
  end

  private

  def resource_url(resource)
    path_method = "#{resource.kind}_path".to_sym
    respond_to?(path_method) ? send(path_method, resource.id) : nil
  end

  def resource_kind_label(resource)
    # Alias "variables" as "secrets" for the UI display
    return "secret" if resource.kind == "variable"

    resource.kind
  end
end
