def fill_autocomplete(field, options = {})
  fill_in field, with: options[:with]

  page.execute_script %Q{ $('##{field}').trigger('focus') }
  page.execute_script %Q{ $('##{field}').trigger('keydown') }
  page.should have_selector('ul.ui-autocomplete li.ui-menu-item .autocomplete-entry')
  selector = %Q{ul.ui-autocomplete li.ui-menu-item .autocomplete-entry:contains("#{options[:select]}")}
  page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
end

Given(/^I click the "([^"]*)" button$/) do |button|
  click_button button
end

Given(/^I visit the editable Group page/) do
  step %Q(I visit "/ui/groups/prod/analytics-db/secrets-users")
end

Then(/^the "Add Member Modal" is present$/) do
  expect(page).to have_selector('#add-user-modal', visible: true)
  expect(page).to have_content('Add Member to')
  expect(page).to have_content('analytics-db/secrets-users')
end

Then(/^I type "([^"]*)" into the "([^"]*)" autocomplete and select "([^"]*)"$/) do |str, modal, select_value|
  fill_autocomplete 'member_id', with: str, select: select_value
end

Then(/^I click the "Add Member Modal" "([^"]*)" button$/) do |user|
  within('#add-user-modal') do
    click_button 'Add'
  end
end

Given(/^I click the "([^"]*)" button for "([^"]*)"$/) do |button, member|
  find('#members-table').find("a[data-name='#{member}']").click()
end

Given(/^I visit the "([^"]*)" Group page$/) do |group_name|
  step %Q(I visit "/ui/groups/#{group_name}")
end

Given(/^I search for "([^"]*)" in the "([^"]*)" section$/) do |search_term, section|
  within('#members-table') do
    fill_in('search', with: search_term)
    find('.input-group-btn > button').click()
    sleep(2)
  end
end

Then(/^"([^"]*)" is present in the message$/) do |search_term|
  within('.alert-success') do
    expect(page).to have_content(search_term)
  end
end
