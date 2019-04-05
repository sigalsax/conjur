ldap_root_url = "/ui/ldap/connection_details/edit"

##################################################
# Connection Test
##################################################

Given(/^I visit the LDAP page/) do
  visit(ldap_root_url)
  expect(page).to have_selector("#ldap-sync form")
end

Given(/^the LDAP connect config stage is empty/) do
  expect(find_field('host').value).to eq ''
  expect(find_field('base_dn').value).to eq ''
  expect(find_field('bind_dn').value).to eq ''
  expect(find_field('bind_password').value).to eq ''
end

Then(/^I am on the LDAP Connect stage$/) do
  expect(page).to have_selector("#connection-test-new")
end

Given(/^I fill in all of the good connect details of LDAP$/) do
  select 'Unencrypted', :from => 'connect_type'
  fill_in 'host', with: 'ldapserver'
  fill_in 'port', with: '389'
  fill_in 'base_dn', with: 'dc=example,dc=org'
  fill_in 'bind_dn', with: 'cn=admin,dc=example,dc=org'
  fill_in 'bind_password', with: 'admin'
end

Then(/^I am on the LDAP Select Users stage$/) do
  expect(page).to have_selector('#connection-details-complete')
  expect(page).to have_selector('#users-selection-title')
end

Given(/^I fill in all of the bad connect details of LDAP$/) do
  select 'Unencrypted', :from => 'connect_type'
  fill_in 'host', with: 'ldapserver'
  fill_in 'port', with: '389'
  fill_in 'base_dn', with: 'dc=example,dc=org'
  fill_in 'bind_dn', with: 'cn=admin,dc=example,dc=org'
  fill_in 'bind_password', with: 'BAD PASSWORD'
end

Then(/^I see an LDAP Connect error$/) do
  expect(page).to have_selector("#connection-test-error")
end

##################################################
# Select Users
##################################################

Given(/^I fill in "Select Users" users with good filters$/) do
  fill_in 'user_filter', with: '(objectClass=posixAccount)'
  fill_in 'group_filter', with: '(objectClass=posixGroup)'
  fill_in 'user_name', with: 'cn'
  fill_in 'group_name', with: 'cn'
end

Then(/^I see a list of selected users and groups$/) do
  expect(page).to have_selector('#selected-users-preview')
  # Don't want to couple too closely to ldap-sync project's fixture data,
  # but a few results for each is probably a safe assumption
  assert_selector('.group-results-list li', minimum: 3)
  assert_selector('.user-results-list li', minimum: 3)
end

Then(/^I see an option to change my filters$/) do
  expect(page).to have_selector('#users-selection-title')
end

Then(/^I see an option to save the selected users$/) do
  expect(page).to have_selector('#save-selected-users-title')
end

Given(/^I fill in "Select Users" users with bad filters$/) do
  fill_in 'user_filter', with: '(objectClass=posixAccount)'
  fill_in 'group_filter', with: '(objectClass=posixGroup' # <-- NB. no paren
  fill_in 'user_name', with: 'cn'
  fill_in 'group_name', with: 'cn'
end

Then(/^I see the correct selected users error$/) do
  expect(page).to have_selector('#selected-users-error-title')
  # Error string from LDAP: Unlikely to change 
  expect(page).to have_content('Filter contains syntax error')
end

Then(/^I don't see a list of selected users and groups$/) do
  expect(page).not_to have_selector('#selected-users-preview')
end

##################################################
# Save users for import
##################################################

Then(/^I see "How to Import" instructions$/) do
  expect(page).to have_selector('#how-to-import-title')
end


Given(/^the LDAP connect config stage is prepopulated$/) do
  expect(find_field('connect-server').value).to eq 'ldapserver'
  expect(find_field('connect-port').value).to eq '389'
  expect(find_field('base-dn').value).to eq 'dc=example,dc=org'
  expect(find_field('bind-dn').value).to eq 'cn=admin,dc=example,dc=org'
end


##################################################
# General Utility
##################################################

require 'cucumber/rspec/doubles'
require 'rest_client'

Then(/^The connect will error$/) do
  allow_any_instance_of(LdapController).to receive(:post_to_connect)
    .and_raise("some error")
end

Then(/^I click "([^"]*)"$/) do |title|
  click_button title
end

# Then(/^I click "([^"]*)"$/) do |title|
#   click_button title
# end

Given(/^I take a picture$/) do
  screenshot_and_save_page
end
