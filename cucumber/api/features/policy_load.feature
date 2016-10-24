Feature: Updating policies

  The initial policy is loaded using the `possum` command line tool, typically running as a one-off container
  command inside the container itself.

  The initial policy create sub-policies which can be modified by privileged users.

  Background:
    Given I am the super-user
    And I successfully PUT "/policies/:account/policy/bootstrap" with body:
    """
    - !policy
      id: @namespace@
      body:
      - !user alice
      - !user bob
      - !user eve

      - !policy
        id: dev
        owner: !user alice
        body:
        - !policy
          id: db
          body: []

      - !permit
        resource: !policy dev/db
        privilege: [ update ]
        role: !user bob
    """

  Scenario: A role with "update" privilege can update a policy.
    When I login as "bob"
    Then I successfully PUT "/policies/:account/policy/:namespace/dev/db" with body:
    """
    - !layer
    """
    And I successfully GET "/resources/:account/layer/:namespace/dev/db"

  Scenario: A role without any privilege cannot update a policy.
    When I login as "eve"
    When I PUT "/policies/:account/policy/:namespace/dev/db" with body:
    """
    - !layer
    """
    Then it's forbidden

