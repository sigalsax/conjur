@model
@policy
Feature: Group model exposes relevant and sanitized information.

  Scenario: Verify fields of a User group.
    When I display the group "ci-admin"
    Then the JSON should be:
    """
    {
      "id": "ci-admin",
      "kind": "group",
      "owner": "cucumber:user:admin"
    }
    """
    And the group "ci-admin" should not be "editable"

  Scenario: 'description' annotation is handled specially
    Then the "description" of the group "prod/analytics-db/secrets-users" should be:
    """
    Members are able to fetch all secrets in this policy.
    """
    And the "annotations" of the group "prod/analytics-db/secrets-users" should not include "description"

  Scenario: 'editable' is true when the annotation is set and the current user is admin of the group.
    Then the group "prod/analytics-db/secrets-users" should be "editable"

  Scenario: 'editable' is false when the annotation is set and the current user is not admin of the group.
    Given I login as "katarina.meij"
    Then the group "prod/analytics-db/secrets-users" should not be "editable"

  Scenario: 'editable' annotation is handled specially
    Then the "annotations" of the group "prod/analytics-db/secrets-users" should not include "editable"
