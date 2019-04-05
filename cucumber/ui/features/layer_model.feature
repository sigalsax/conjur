@model
@policy
Feature: Layer model exposes relevant and sanitized information.

  Scenario: Verify non-SSH fields of a Layer
    When I display the layer "prod/frontend/v1"
    Then a subset of the JSON should include:
    """
    {
      "id": "prod/frontend/v1",
      "kind": "layer",
      "owner": "cucumber:policy:prod/frontend/v1",
      "hosts": [
        "cucumber:host:app-001.itp.myorg.com",
        "cucumber:host:app-002.itp.myorg.com",
        "cucumber:host:app-003.itp.myorg.com",
        "cucumber:host:app-004.itp.myorg.com",
        "cucumber:host:app-005.itp.myorg.com"
      ]
    }
    """

  @v4
  Scenario: Verify the SSH fields of a Layer
    When I display the layer "prod/frontend/v1"
    Then a subset of the JSON should include:
    """
    {
      "ssh": {
        "admins": [
          "cucumber:group:developers-admin"
         ],
         "users": [
           "cucumber:group:developers",
           "cucumber:group:researchers"
         ]
       }
     }
   """

  @v4
  Scenario: Verify SSH access shown on a Layer
    When I display the "ssh" of layer "prod/salt/v1"
    Then the JSON should be:
    """
    {
      "users": [
      ],
      "admins": [
        "cucumber:group:operations"
      ]
    }
    """
