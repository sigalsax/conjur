@v4
# Needs to update role membership programmatically. Needs to be able to search role members
@Javascript
@policy
Feature: Users, Groups, and Layers can be added and removed from a Group's Members.

  Background: I am logged in and on Group page
    Given I am logged in as admin
    And I visit the editable Group page

  Scenario: Add a Member through a modal.
    Given I click the "Add Member" button
    Then the "Add Member Modal" is present
    And I type "car" into the "Add Member Modal" autocomplete and select "carol.rodriquez"
    And I click the "Add Member Modal" "Add" button
    Then "carol.rodriquez" is present in the "Members" table
    And "Successfully added user carol.rodriquez to the prod/analytics-db/secrets-users group" is present in the message

  Scenario: Remove a Member through a modal confirmation.
    Given I click the "Remove" button for "carol.rodriquez"
    And the "Remove Member Modal" is present for "carol.rodriquez"
    And I click the "Remove Member Modal" "Confirmation" button
    Then "carol.rodriquez" is not present in the "Members" table
    And "Successfully removed user carol.rodriquez from the prod/analytics-db/secrets-users group" is present in the message

  Scenario: Perform a search on the members section
    And I visit the "researchers" Group page
    And I search for "dustin" in the "Members" section
    Then "dustin.bailey" is present in the "Members" table
    And "adele.dupuis" is not present in the "Members" table

  Scenario: Add a Layer to a Group's Members through a Modal
    Given I click the "Add Member" button
    Then the "Add Member Modal" is present
    And I type "prod" into the "Add Member Modal" autocomplete and select "prod/ansible/v1"
    And I click the "Add Member Modal" "Add" button
    Then "prod/ansible/v1" is present in the "Members" table

  Scenario: Remove a Layer through a modal confirmation.
    Given I click the "Remove" button for "prod/ansible/v1"
    And the "Remove Member Modal" is present for "prod/ansible/v1"
    And I click the "Remove Member Modal" "Confirmation" button
    Then "prod/ansible/v1" is not present in the "Members" table
