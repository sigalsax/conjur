Given(/^I login as "([^"]*)"$/) do |login|
  login_as login
  step "the response status is 302"
  step %Q(the "location" header is "http://example.org/ui")
end

# These are specifically for PhantomJS run tests
# TODO - Refactor these to allow them to take any user as above
Given(/^I login as admin$/) do
  fill_in 'login[username]', with: 'admin'
  fill_in 'login[password]', with: 'secret'

  click_button 'Sign In'
  expect(page).to have_content('Sign Out')
end

Given(/^I am logged in as admin/) do
  step %Q(I visit "/ui/login/new")
  step %Q(I login as admin)
end
