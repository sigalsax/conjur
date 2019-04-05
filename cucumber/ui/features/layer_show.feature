@policy
Feature: Display Layers list and details page in rails

Background: I am logged in
  Given I login as "admin"
  And I visit "/ui/layers"

Scenario: The layer details page renders
  And I click the link for "prod/frontend/v1"
  Then I am on the detail page for "prod/frontend/v1"
  And in the "Hosts" section I see "app-001.itp.myorg.com"

Scenario: The layer details page renders
  And I click the link for "prod/frontend/v1"
  Then I am on the detail page for "prod/frontend/v1"
  And in the "Group Memberships" subsection I see "prod/inventory/v1/consumers"

@v4
Scenario: The layer details page shows SSH access and other permissions
  And I click the link for "prod/frontend/v1"
  Then I am on the detail page for "prod/frontend/v1"
  And in the "SSH Access" section I see "developers-admin"
  And in the "Permissions" section I see "prod/inventory/v1/consumers"
  And in the "Permissions" section I see "prod/analytics/v1/data-producers" with "put"

Scenario: Show the details of a page of a Layer with no group memberships
  And I click the link for "ci/jenkins/v1/executors"
  Then I am on the detail page for "ci/jenkins/v1/executors"
  And in the "Group Memberships" subsection I see "This object doesn't belong to any groups."
