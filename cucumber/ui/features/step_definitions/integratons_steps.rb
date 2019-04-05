Given(/^I view the list page for "([^"]*)"$/) do |type|
  visit "/ui/#{type}"
end

Then(/^I should see the Integrations column in the table$/) do
  within(".box-body table") do
    page.should have_content(/Integrations/i)
  end
end

Then(/^I should see a resource in the list called "([^"]*)"$/) do |resource|
  within(".box-body table") do
    page.should have_content(/#{resource}/i)
  end
end

Then(/^that resource should have at least one integration button visible$/) do
  within(".box-body table") do
    page.should have_selector('.integration.buttonize.outline.no-click')
  end
end

Given(/^I view the details page for "([^"]*)"$/) do |resource|
  visit "#{resource}"
end

Then(/^I should see the Integrations section in the details box$/) do
  within("#details .box-body") do
    page.should have_content(/Integrations/i)
  end
end

Then(/^I should see at least one integration button visible$/) do
  within("#details .box-body") do
    page.should have_selector('.integration.buttonize.outline.no-click')
  end
end
