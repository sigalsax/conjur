@policy
Feature: Display a host page

  Scenario: Unauthenticated request redirects to the login page
    When I get "/ui/hosts/analytics-002.itr.myorg.com"
    Then the response status is 302
    And the "Location" header is "http://example.org/ui/login/new"

  Scenario: While logged in as admin, display the the page of a regular host.
    Given I login as "admin"
    Then I can get "/ui/hosts/analytics-002.itr.myorg.com"

  @v4
  # katarina gets given permission on the host by virtue of being a
  # member of a group that has SSH access.
  Scenario: Attempt to display a host page with forbidden sections.
    Given I login as "katarina.meij"
    Then I can get "/ui/hosts/executor-testing.itci.myorg.com"
    And the owner should be displayed
    And the role graph should be forbidden

  Scenario: The host details page renders
    Given I login as "admin"
    And I visit "/ui/hosts"
    And I click the link for "analytics-002.itr.myorg.com"
    Then I am on the detail page for "analytics-002.itr.myorg.com"

  Scenario: The host details page shows layer membership
    Given I login as "admin"
    And I visit "/ui/hosts"
    And I click the link for "analytics-002.itr.myorg.com"
    Then I am on the detail page for "analytics-002.itr.myorg.com"
    And in the "Layer Memberships" subsection I see "prod/analytics/v1"

  @v4 
  Scenario: The host details page contains information about SSH access and permissions
    Given I login as "admin"
    And I visit "/ui/hosts"
    And I click the link for "analytics-002.itr.myorg.com"
    Then I am on the detail page for "analytics-002.itr.myorg.com"
    And in the "SSH Access" section I see "anton.honkala"
    And in the "Permissions" section I see "prod/analytics/v1"
    And in the "Permissions" section I see "prod/analytics-db/secrets-users" with "execute, read"
