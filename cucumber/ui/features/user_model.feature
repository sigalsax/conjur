@model
@policy
Feature: User model exposes relevant and sanitized information.

  Scenario: Verify fields of a User.
    When I display the user "sam.davies"
    Then the JSON should be:
    """
    {
      "kind": "user",
      "owner": "cucumber:user:admin"
    }
    """

  @v4
  Scenario: Verify displayed permissions.
    When I display the "permissions" of user "sam.davies"
    Then the JSON should be:
    """
    [
      6,
      [
        {
          "owner": false,
          "role": "cucumber:layer:prod/openvpn/v1",
          "privileges": [
            "execute",
            "read",
            "update"
          ],
          "resource": "cucumber:host:cloud.itp.myorg.com"
        },
        {
          "owner": false,
          "role": "cucumber:layer:prod/openvpn/v1",
          "privileges": [
            "execute",
            "read",
            "update"
          ],
          "resource": "cucumber:host:office.itp.myorg.com"
        },
        {
          "owner": false,
          "role": "cucumber:layer:prod/salt/v1",
          "privileges": [
            "execute",
            "read",
            "update"
          ],
          "resource": "cucumber:host:salt-master.itp.myorg.com"
        },
        {
          "owner": false,
          "role": "cucumber:layer:prod/openvpn/v1",
          "privileges": [
            "read"
          ],
          "resource": "cucumber:layer:prod/openvpn/v1"
        },
        {
          "owner": false,
          "role": "cucumber:layer:prod/salt/v1",
          "privileges": [
            "read"
          ],
          "resource": "cucumber:layer:prod/salt/v1"
        },
        {
          "owner": false,
          "role": "cucumber:user:sam.davies",
          "privileges": [
            "read"
          ],
          "resource": "cucumber:user:sam.davies"
        }
      ]
    ]
    """
