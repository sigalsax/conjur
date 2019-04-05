When /^I(?: can)* add the user "(.*?)" to the group "(.*?)"$/ do |user, group|
  header 'Accept', 'application/json'
  @response = post "/ui/roles/#{account}%3Agroup%3A#{CGI.escape(group)}/members", member_id: "#{account}:user:#{user}"
  expect(@response.status).to eq(204)
end

When /^I(?: can)* remove the user "(.*?)" from the group "(.*?)"$/ do |user, group|
  header 'Accept', 'application/json'
  @response = delete "/ui/roles/#{account}%3Agroup%3A#{CGI.escape(group)}/members/#{account}%3Auser%3A#{user}"
  expect(@response.status).to eq(204)
end
