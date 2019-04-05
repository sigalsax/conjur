Then(/^I( successfully| can)? get "([^"]*)"$/) do |must, path|
  @response = get path, {}
  visit path
  if must
    expect(@response.status).to eq(200)
  end
end

Then(/^it is forbidden$/) do
  expect(@response.status).to eq(403)
end

Then(/^the response status is (\d+)$/) do |status|
  expect(@response.status).to eq(status.to_i)
end

Then(/^the "([^"]*)" header is "([^"]*)"$/) do |header_name, value|
  expect(@response[header_name]).to eq(value)
end

Then(/^show me the page$/) do
  print page.html
end

Then(/^I do a health check$/) do
  @response = options '/'
end
