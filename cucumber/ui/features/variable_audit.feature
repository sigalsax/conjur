@v4
@policy
Feature: Display audit history for variable in details page

Background: I am logged in
  Given I am logged in as admin
  And I reset the "prod/inventory-db/password" variable "30" times
  And I visit "ui/secrets/prod/inventory-db/password"

@javascript
  Scenario: Verify the audit events display correctly
  Then I should have "10" table rows in the "audit_events" table
  Then the page does not have the "Show Less" button for the "audit_events" table
  And I click the "Show More" button for the "audit_events" table
  Then the page does have the "Show Less" button for the "audit_events" table
  Then I should have "20" table rows in the "audit_events" table
  And I click the "Show More" button for the "audit_events" table
  Then I should have "30" table rows in the "audit_events" table
  And I click the "Show Less" button for the "audit_events" table
  Then I should have "20" table rows in the "audit_events" table
  And I click the "Show Less" button for the "audit_events" table
  Then I should have "10" table rows in the "audit_events" table
  Then the page does not have the "Show Less" button for the "audit_events" table
