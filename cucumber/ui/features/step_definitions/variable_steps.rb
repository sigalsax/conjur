Then(/^I update the secret value to "([^"]*)"$/) do |value|
  fill_in 'secret-value', with: value
  find('#save-secret-value').click
end

Then(/^I see that the secret-value has finished loading$/) do
  find('#secret-value:not(.loading)')
end

Then(/^the page does not have the "([^"]*)" button for the "(.+)" table$/) do |button, table|
  expect(find_by_id("#{table}-table")).not_to have_button(button)
end

Then(/^the page does have the "([^"]*)" button for the "(.+)" table$/) do |button, table|
  expect(find_by_id("#{table}-table")).to have_button(button)
end

Given(/^I reset the "(.*)" variable "(\d+)" times$/) do |variable, num_resets|
  Bundler.with_clean_env do
    for reset_num in 1..num_resets.to_i
      `conjur variable values add #{variable} "foo-#{reset_num}"`
    end
  end
end

Given(/^I click the "([^"]*)" button for the "(.+)" table$/) do |button, table|
  find_by_id("#{table}-table").find_button(button).click()
end

And(/^I reload until successful rotation shows up in audit logs$/) do
  Timeout.timeout(20.seconds) do
    criteria_met = false
    loop do
      page.evaluate_script("window.location.reload()")
      begin
        step 'in the "Audit Events" section I see "reported rotation:rotate"'
        criteria_met = true
      rescue StandardError
        criteria_met = false
      end
      break if criteria_met
      sleep 2
    end
    expect(criteria_met).to be(true)
  end
end
