module ClusterHelper

  def display_light(label, color, tooltip = '')
    light = [content_tag(:i, '', class: "icon-circle icon-cluster-#{color}"), label].join.html_safe
    return light unless tooltip.present?

    content_tag(:div, data: {toggle: 'tooltip', placement: 'bottom'}, title: tooltip) do
      concat(light).concat(content_tag(:i, '', class: 'icon-info-circled help-text help-text-cluster floatright')).html_safe
    end
  end

end
