Then(/^I see label and horizontal bar graph of most active secrets$/) do
  within_section("Most Active Secrets") do
    expect(page).to have_selector('.horizontal-bar-chart', count: 1)
  end
end

Then(/^I should have "(\d+)" table rows in the "(.+)" table$/) do |number_of_rows, table|
  expect(find_by_id("#{table}-table")).to have_css("tbody > tr", :count => number_of_rows.to_i)
end
