Then(/^I should have "(\d+)" table rows in the resource list$/) do |number_of_rows|
  expect(find_by_id('resource-list')).to have_css('table tbody > tr', :count => number_of_rows.to_i)
end

Then(/^the resource list does( not)? have the "([^"]*)" button$/) do |inverse , button|
  if inverse
    expect(find_by_id('resource-list')).not_to have_button(button)
  else
    expect(find_by_id('resource-list')).to have_button(button)
  end
end

Given(/^I click the "([^"]*)" button in the resource list$/) do |button|
  find('#resource-list button', :text => button).trigger('click')
  wait_for_ajax
end
