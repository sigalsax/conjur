@policy
Feature: Show more/less buttons on resource list page (index)

  Background: I am logged in
    Given I am logged in as admin

  @javascript
  Scenario: Verify resource list show more/less functionality
    Given I view the list page for "users"
    Then I should have "20" table rows in the resource list
    And the resource list does not have the "Show Less" button

    Then I click the "Show More" button in the resource list
    And I should have "40" table rows in the resource list
    And the resource list does have the "Show Less" button

    Then I click the "Show More" button in the resource list
    And I should have "60" table rows in the resource list

    Then I click the "Show Less" button in the resource list
    And I should have "40" table rows in the resource list

    Then I click the "Show Less" button in the resource list
    And I should have "20" table rows in the resource list
    And the resource list does not have the "Show Less" button
