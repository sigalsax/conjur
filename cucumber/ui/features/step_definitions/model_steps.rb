When(/^I display the (\w+) "([^"]*)"$/) do |kind, id|
  new_conjur_object(kind, id)
end

When(/^I display the "([^"]*)" of (\w+) "([^"]*)"$/) do |method, kind, id|
  data = new_conjur_object(kind, id).send(method)
  result = if method == "audit"
    if data.first == :forbidden
      [ "forbidden" ]
    else
      stringify = lambda do |o|
        if o.respond_to?(:kind)
          [ o.kind, o.id ].join(" ")
        else
          o.to_s
        end
      end
      data.map do |audit|
        audit.message stringify, stringify
      end
    end
  else
    data.as_json
  end
  set_json JSON.pretty_generate(result)
end

Then(/^the "([^"]*)" of the (\w+) "([^"]*)" should be:$/) do |field, kind, id, value|
  obj = new_conjur_object(kind, id)
  expect(obj.send(field).as_json).to eq(value)
end

Then(/^the (\w+) "([^"]*)" should( not)? be "([^"]*)"$/) do |kind, id, inverse, field|
  obj = new_conjur_object(kind, id)
  test_method = inverse ? :to_not : :to
  expect(obj.send("#{field}?")).send(test_method, be_truthy)
end

Then(/^the "([^"]*)" of the (\w+) "([^"]*)" should not include "([^"]*)"$/) do |field, kind, id, name|
  obj = new_conjur_object(kind, id)
  data = obj.send(field)
  expect(data).to be_instance_of(Hash)
  expect(data).to_not have_key(name)
end

When(/^I fetch (all|\d+) roles with ssh(?: "([^"]*)")? on host "([^"]*)"$/) do |limit, privilege, host_id|
  roles = new_conjur_object('host', host_id).ssh(limit: limit == "all" ? nil : limit.to_i).select do |member|
    privilege.nil? || member.privileges.member?(privilege)
  end.map(&:role).map(&:roleid)
  set_json roles
end
