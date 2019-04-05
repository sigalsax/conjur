Then(/^the owner should be displayed$/) do
  page.should have_css('#details .owner')
end

Then(/^the role graph should be forbidden$/) do
  page.should have_css('#role-graph .forbidden')
end

Then(/^the group members are not editable$/) do
  page.should_not have_css('#add-user-modal')
end

Then(/^the group members are editable$/) do
  page.should have_css('#add-user-modal')
end

Then(/^I can see the "([^"]*)" section with "([^"]*)" present$/) do |section, element|
  header = find('h3', :text => /\A#{section}\z/)
  section_box = header.first(:xpath,".//..").first(:xpath,".//..")
  expect(section_box).to have_content(element)
end

Then(/^in the "([^"]*)" section I see "([^"]*)" with "([^"]*)"$/) do |section, item1, item2|
  row = step %Q(in the "#{section}" section I see "#{item1}")
  row.first('td', text: item2)
end

Then(/^in the "([^"]*)" section I see "([^"]*)"$/) do |section, item1|
  section = find(:xpath, "//h3[./text()='#{section}']").first(:xpath, ".//..").first(:xpath, ".//..")
  section.first('*', text: item1).first(:xpath, ".//..").first(:xpath, ".//..").first(:xpath, ".//..")
end

Then(/^in the "([^"]*)" section I see an element matching "([^"]*)"$/) do |section, item1|
  section = find(:xpath, "//h3[./text()='#{section}']").first(:xpath, ".//..").first(:xpath, ".//..")
  section.find(item1)
end

Then(/^in the "([^"]*)" column of the row containing "([^"]*)" I see "([^"]*)"$/) do |column_text, row_text, value|
  row = find(:xpath, "//td[./text()='#{row_text}']").first(:xpath, ".//..")

  col_index =
    find_all(:xpath, "//th").
    to_enum.with_index.
    select { |th, idx| th.text[column_text] }.
    first.last

  cell = row.find(:xpath, "./td[#{col_index + 1}]")

  expect(cell.text).to eq(value)
end

Then(/^in the "([^"]*)" subsection I see "([^"]*)"$/) do |section, item|
  section = find(:xpath, "//h4[./text()='#{section}']").first(:xpath, ".//..").first(:xpath, ".//..")
  section.should have_content(item)
end

Then(/^I am on the detail page for "([^"]*)"$/) do |page|
  within(".content-header") do
    page.should have_content(page)
  end

  within(".dl-horizontal") do
    page.should have_content(page)
  end
end

Then(/^"([^"]*)" is present in the "([^"]*)" table$/) do |member, section|
  within_section(section) do
    expect(page).to have_link(member)
  end
end

Then(/^"([^"]*)" is not present in the "([^"]*)" table$/) do |member, section|
  within_section(section) do
    expect(page).to_not have_link(member)
  end
end

# Helpers for Delete modal
Then(/^the "([^"]*)" is present for "([^"]*)"$/) do |_, member|
  expect(page).to have_selector('#delete-confirmation-modal', visible: true)
  expect(page).to have_content('Are you sure you want to remove')
  expect(page).to have_content(member)
end

Then(/^I click the "([^"]*)" "Confirmation" button$/) do |_|
  find('#delete-confirmation-modal').find('a.confirm').click()
end

Then(/^the page should contain the selector "([^"]*)"$/) do |selector|
  expect(page).to have_selector selector
end

Then(/^the page should not contain the selector "([^"]*)"$/) do |selector|
  expect(page).not_to have_selector selector
end

And(/^I click on selector "([^"]*)"$/) do |selector|
  find(selector).click
end
