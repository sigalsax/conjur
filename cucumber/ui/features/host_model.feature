@model
@policy
Feature: Host model exposes relevant and sanitized information.

  Scenario: Verify fields of a Host.
    When I display the host "analytics-001.itr.myorg.com"
    Then a subset of the JSON should include:
    """
    {
      "id": "analytics-001.itr.myorg.com",
      "kind": "host", 
      "owner": "cucumber:user:admin"
    }
    """

  @v4
  Scenario: Verify SSH access shown on a Host
    When I fetch all roles with ssh "update" on host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    [
      "cucumber:user:admin",
      "cucumber:user:anton.honkala",
      "cucumber:user:constance.bourgeois",
      "cucumber:user:freddy.alvarez",
      "cucumber:user:hector.jackson",
      "cucumber:user:jane.alderman",
      "cucumber:user:meline.lopez",
      "cucumber:user:noelie.garnier",
      "cucumber:user:wayne.walker"
    ]
    """
    And I fetch all roles with ssh "execute" on host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    [
      "cucumber:user:alberto.morgan",
      "cucumber:user:alfredo.coleman",
      "cucumber:user:annie.diaz",
      "cucumber:user:belen.cano",
      "cucumber:user:benjamin.garnier",
      "cucumber:user:emmi.korpela",
      "cucumber:user:faiz.rooker",
      "cucumber:user:gabin.dupont",
      "cucumber:user:jimmy.knight",
      "cucumber:user:lotta.aho",
      "cucumber:user:sofia.tikkanen",
      "cucumber:user:soledad.reyes",
      "cucumber:user:ted.holland"
    ]
    """

  @v4
  Scenario: SSH access can be paginated
    When I fetch 3 roles with ssh on host "analytics-001.itr.myorg.com"
    Then the JSON should be:
    """
    [
      "cucumber:user:admin",
      "cucumber:user:anton.honkala",
      "cucumber:user:constance.bourgeois"
    ]
    """
