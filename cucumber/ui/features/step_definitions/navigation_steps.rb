Then(/^I visit "([^"]*)"$/) do |path|
  visit path
end

And(/^I click the link for "([^"]*)"$/) do |page|
  first(:link, page).click
end

And(/^I click the link for "([^"]*)" in this namespace$/) do |page|
  first(:link, "#{@namespace}/#{page}").click
end

And(/^I visit the page for the variable "([^"]*)" in this namespace( with expiration enabled)*$/) do |page, expiration_enabled|
  visit "/ui/secrets/#{@namespace}/#{page}" + (expiration_enabled ? '?expiration_enabled=true' : '')
end
