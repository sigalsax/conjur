@javascript
@policy
Feature: Hosts can be added and removed from a Layer.

Background: I am logged in and on an editable Layer page
  Given I am logged in as admin
  And I visit the editable Layer page

@v4
# needs to be able to update a role programmatically
Scenario: Add a Host through a modal.
  Given I click the "Add Host" button
  Then the modal "Add Host" is present with "Add Host to"
  And I type "ans" into the "Add Host Modal" autocomplete and select "ansible.ee"
  And I click the "Add Host Modal" "Add" button
  And in the "Hosts" section I see "ansible.ee"
  And "Successfully added host ansible.ee to the prod/frontend/v1" is present in the message

@v4
Scenario: Remove a Host through a modal confirmation.
  Given I click the "Remove" button for "ansible.ee" in the "Hosts" section
  And the "Remove Host Modal" is present for "ansible.ee"
  And I click the "Remove Host Modal" "Confirmation" button
  Then "ansible.ee" is not present in the "Hosts" table
  And "Successfully removed host ansible.ee from the prod/frontend/v1" is present in the message


Scenario: Add and remove a token from a layer.
  Given I click the "New Token" button in the "Host Factories" section
  Then I see a new token present in the "Host Factories" section
  And I click the "Remove" button in the "Host Factories" section
  Then I see the token has been removed from the "Host Factories" section
