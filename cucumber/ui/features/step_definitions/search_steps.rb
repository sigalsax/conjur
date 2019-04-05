When(/^I query for "([^"]*)" through the quick search$/) do |search_term|
  visit "/ui/search?query=#{search_term}"
end

When(/^I query for "([^"]*)" through the url$/) do |search_term|
  visit "/ui/search?query#{search_term}"
end

Then(/^I should see all resource boxes checked$/) do
  within("#resource-filters") do
    page.should have_selector('input[type=checkbox]', count: 7)
  end
end

And(/^I should see result count in the header$/) do
  page.should have_selector('.content-header h2 span')
  within(".content-header h2 span") do
    page.should have_content("Found ")
  end
end

And(/^I should see "([^"]*)" in the search results$/) do |search_term|
  within(".search-table") do
    page.should have_content(/#{search_term}/i)
  end
end

Then(/^I should see no results$/) do
  within("#search-group") do
    page.should have_content(/(no results found)/i)
  end
end

And(/^I should not see "([^"]*)" in the search results$/) do |search_term|
  within(".search-table") do
    page.should have_no_content(/#{search_term}/i)
  end
end

And(/^I should see pagination$/) do
  page.should have_selector('.pagination-inner')
end

And(/^I should see page "([^"]*)" of search results$/) do |page|
  expect(current_url).to have_content(/search%5Bpage%5D=#{page}/)
end

And(/^I click the pagination link for page "([^"]*)"$/) do |page|
  click_link(page)
end

And(/^I click the pagination link for View All$/) do
  click_link("View All")
end

And(/^I should see all results$/) do
  expect(current_url).to have_content(/search%5Bpage%5D=all/)
  within(".search-table") do
    page.should have_content("prod/admin-ui/v1/ssl/certificate")
  end
end

Then(/^I check off "([^"]*)"$/) do |checkbox|
  within("#new_search") do
    check(checkbox)
  end
end

Then(/^I uncheck "([^"]*)"$/) do |checkbox|
  within("#new_search") do
    uncheck(checkbox)
  end
end
