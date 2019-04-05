@v4
@javascript
@policy
@ldap
Feature: LDAP Sync works

  # TODO add tests for SSL/TLS
  # TODO add tests for out of order stage redirection
  # TODO add tests for API calls to ldap-sync failing with webmock
  # TODO add tests for choices being remembered (make them always remembered)

  ##################################################
  # Test Connection
  ##################################################

  Background: I am logged in and on LDAP page
    Given I am logged in as admin
    And I visit the LDAP page
    And the LDAP connect config stage is empty

  Scenario: Good connection details are successful
    Given I am on the LDAP Connect stage
    And I fill in all of the good connect details of LDAP
    And I click "Connect"
    Then I am on the LDAP Select Users stage

  Scenario: Bad connection details show an error
    Given I am on the LDAP Connect stage
    And I fill in all of the bad connect details of LDAP
    And I click "Connect"
    Then I see an LDAP Connect error

  ##################################################
  # Select Users
  ##################################################

  Scenario: Selecing users with good filters works
    Given I am on the LDAP Connect stage
    And I fill in all of the good connect details of LDAP
    And I click "Connect"
    And I fill in "Select Users" users with good filters
    And I click "Preview Selected Users"
    Then I see a list of selected users and groups
    And I see an option to change my filters
    And I see an option to save the selected users

  Scenario: Selecting users with bad filters errors
    Given I am on the LDAP Connect stage
    And I fill in all of the good connect details of LDAP
    And I click "Connect"
    And I fill in "Select Users" users with bad filters
    And I click "Preview Selected Users"
    Then I see the correct selected users error

  ##################################################
  # Save Users for import
  ##################################################

  Scenario: Saving selected users for import works
    Given I am on the LDAP Connect stage
    And I fill in all of the good connect details of LDAP
    And I click "Connect"
    And I fill in "Select Users" users with good filters
    And I click "Preview Selected Users"
    And I click "Save Selected Users"
    Then I see "How to Import" instructions
