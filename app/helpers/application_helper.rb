module ApplicationHelper
  ConjurDummyObject = Struct.new(:account, :kind, :id)

  def owner_is_policy? object
    object.owner.policy?
  end

  def policy_unqualified_id object
    object.id[object.owner.id.length+1..-1]
  end

  def relationship_count_label count, label, prefix: ""
    label = "This #{@conjur_object.kind} has #{prefix}#{pluralize count, label}"
    label << " matching '#{@search}'" unless @search.blank?
    label
  end

  def link_to_object obj
    obj = obj.is_a?(String) ? ConjurDummyObject.new(*obj.split(":", 3)) : obj

    is_rotator = obj.respond_to?(:with_rotator?) && obj.with_rotator?
    classes = [ "link-to" ] +
      (is_rotator ? ['icon-variable-with-rotator'] : ["icon-#{obj.kind}"])

    # TODO this rescue logic should not be here
    #      should be able to refactor as above
    begin
      if obj.respond_to?(:ldap?) && obj.ldap?
        classes << "icon-#{obj.kind}-ldap"
      end
      link_to send("#{obj.kind}_path", obj.id) do
        content_tag(:span, obj.id, class: classes)
      end
    rescue NoMethodError
      h(obj.id)
    rescue RestClient::Forbidden
      %Q(<span class="#{classes.join(' ')}">#{h obj.id}</span>).html_safe
    end
  end

  def audit_events_link_to(obj, limit)
    obj_type = obj.class.to_s.downcase
    link_to(send("audit_events_#{obj_type}_path", obj.id, limit: limit), remote: true) do
      yield
    end
  end

  def audit_events_paginate(filter, obj, limit)
    obj_type = obj.class.to_s.downcase
    link_to(send("#{filter}_#{obj_type}_path", obj.id, limit: limit), remote: true) do
      yield
    end
  end

  def remove_button(resource, member, scroll_to='')
    link_to(
      role_member_path(role_id: resource.roleid, id: member.roleid, scroll_to: scroll_to),
      {
        method: :delete,
        data: {
          name: member.id,
          confirm: 'Are you sure?',
          confirm_type: 'remove-member',
          to_remove: {
            name: member.id,
            type: member.kind
          },
          from: {
            name: resource.id,
            type: resource.kind
          }
        },
        class: 'js-modal-delete btn btn-listItem btn-xs'
      }
    ) do
      '<span class="glyphicon glyphicon-minus-sign"></span>&nbsp; Remove'.html_safe
    end
  end

  def remote_button_for(opts = {}, &block)
    render(
        partial: 'remote_button',
        locals: { block: block }.merge(opts)
    )
  end

  def time_ago timestamp
    time_ago_in_words(timestamp) + " ago".freeze
  end

  def audit_time_tag timestamp
    time_tag timestamp, time_ago(timestamp), title: timestamp
    # ideally a javascript helper would go and do (t) => t.innerText = new Date(t.dateTime).toLocaleString())
  end

  def active_class(path)
    'active' if request.path.downcase.start_with?(path.downcase)
  end
end
