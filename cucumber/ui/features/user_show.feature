@policy
Feature: Display a user

  Scenario: Unauthenticated request redirects to the login page
    When I get "/ui/users/admin"
    Then the response status is 302
    And the "Location" header is "http://example.org/ui/login/new"

  @wip
  Scenario: Display the admin user's own page
    Given I login as "admin"
    Then I can get "/ui/users/admin"

  Scenario: While logged in as admin, display the the page of a regular user
    Given I login as "admin"
    Then I can get "/ui/users/alfredo.coleman"

  @v4
  Scenario: While logged in as admin, audit events are shown on the details page
    Given I login as "admin"
    Then I can get "/ui/users/alfredo.coleman"
    And I can see the "Warnings" section with "There are no warnings available" present
    And I can see the "Audit Events" section with "created role alfredo.coleman" present

  Scenario: A user's details page contains group memberships
    Given I login as "admin"
    Then I can get "/ui/users/alfredo.coleman"
    And in the "Group Memberships" subsection I see "developers"

  Scenario: Display a regular user's own page
    Given I login as "alfredo.coleman"
    Then I can get "/ui/users/alfredo.coleman"


  Scenario: Attempt to display the admin page, as a regular user
    Given I login as "alfredo.coleman"
    And I get "/ui/users/admin"
    Then it is forbidden
