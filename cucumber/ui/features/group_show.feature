@policy
Feature: Display a group page

  Scenario: Unauthenticated request redirects to the login page
    When I get "/ui/groups/prod/analytics-db/secrets-users"
    Then the response status is 302
    And the "Location" header is "http://example.org/ui/login/new"

  Scenario: While logged in as admin, display the the page of a non-editable group.
    Given I login as "admin"
    Then I can get "/ui/groups/ci-admin"
    And the group members are not editable

  Scenario: Display the the page of an editable group, as a group admin.
    Given I login as "sarah.dunlop"
    Then I can get "/ui/groups/prod/analytics-db/secrets-users"
    And the group members are editable

  Scenario: Display an editable group without admin to the group role.
    This user is on the analytics-team, who owns the analytics policy, and
    has the analytics-db/secrets-users group role (as well as read privilege on it).

    Given I login as "jane.alderman"
    Then I can get "/ui/groups/prod/analytics-db/secrets-users"
    And the group members are not editable
  
