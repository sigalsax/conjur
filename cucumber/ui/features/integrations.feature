@policy
Feature: Resources with associated integrations show appropriate badges.

  Background: I am logged in
    Given I login as "admin"

  Scenario: I view a list page that has a resource tagged with an integration annotation
    Given I view the list page for "layers"
    Then I should see the Integrations column in the table
    And I should see a resource in the list called "prod/frontend/v1"
    And that resource should have at least one integration button visible

  Scenario: I view details page for a resource that has an integration annotation
    Given I view the details page for "/ui/layers/prod%2Ffrontend%2Fv1"
    Then I should see the Integrations section in the details box
    And I should see at least one integration button visible
