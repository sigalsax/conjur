@v4
@policy
Feature: members cans be added and removed from a role

  Scenario:
    Given I login as "admin"
    When I add the user "wayne.walker" to the group "ci/chef/secrets-users"
    Then I can remove the user "wayne.walker" from the group "ci/chef/secrets-users"
