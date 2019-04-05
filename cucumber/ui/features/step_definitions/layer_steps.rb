Given(/^I visit the editable Layer page/) do
  step %Q(I visit "/ui/layers/prod/frontend/v1")
end

Then(/^the modal "([^"]*)" is present with "([^"]*)"$/) do |modal_name, content|
  selector = "##{modal_name.downcase.gsub(/ /, '-')}-modal"
  expect(page).to have_selector(selector, visible: true)
  within(selector) do
    find('h3', text: content)
  end
end

Then(/^I click the "Add Host Modal" "([^"]*)" button$/) do |button|
  within('#add-host-modal') do
    click_button button
  end
end

Given(/^I click the "([^"]*)" button for "([^"]*)" in the "([^"]*)" section$/) do |btn_text, row_item, section_name|
  section = find(:xpath, "//h3[./text()='#{section_name}']").first(:xpath, ".//..").first(:xpath, ".//..")
  section.find("a[data-name='#{row_item}']").click()
end

Given(/^I click the "([^"]*)" button in the "([^"]*)" section$/) do |button_text, section|
  within_section(section) do
    click_link button_text
  end
end

Then(/^I see a new token present in the "([^"]*)" section$/) do |section|
  within_section(section) do
    wait_for_ajax { expect(page.text).to match(/[a-z0-9]{45,}/) }
  end
end

Then(/^I see the token has been removed from the "([^"]*)" section$/) do |section|
  within_section(section) do
    wait_for_ajax { expect(page.text).to_not match(/[a-z0-9]{45,}/) }
  end
end
