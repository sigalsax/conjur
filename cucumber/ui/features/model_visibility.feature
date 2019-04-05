@v4
@policy
Feature: Conjur model methods respond approriately when the authenticated role doesn't have access to some data.

  Scenario: User is unauthorized to fetch resource permissions
    Given I login as "alberto.morgan"
    And I display the "permissions" of host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    [
      "forbidden",
      []
    ]
    """
  
  Scenario: User is unauthorized to fetch role members
    Given I login as "alberto.morgan"
    And I display the "members" of host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    [
      "forbidden",
      []
    ]
    """

  Scenario: User is unauthorized to fetch role memberships
    Given I login as "alberto.morgan"
    And I display the "memberships" of host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    [
      "forbidden",
      []
    ]
    """

  Scenario: User is unauthorized to fetch the role graph
    Given I login as "alberto.morgan"
    And I display the "role_graph" of host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    {
      "forbidden": true
    }
    """

  Scenario: User is unauthorized to fetch the audit
    Given I login as "alberto.morgan"
    And I display the "audit_events" of host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    [
      "forbidden",
      []
    ]
    """
