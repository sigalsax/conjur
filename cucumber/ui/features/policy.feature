@policy
Feature: Display policies list and details page in rails

Background: I am logged in
  Given I login as "admin"
  And I visit "/ui/policies"

Scenario: Show the details page of a policy
  When I click the link for "ci/jenkins/admin-ui/v1"
  Then I am on the detail page for "ci/jenkins/admin-ui/v1"
  And in the "Group Memberships" subsection I see "ci/jenkins/admin-ui/v1/secret-managers"
  And in the "Privileges Held" subsection I see "ci/jenkins/admin-ui/v1/secret-managers"
  And in the "Members" section I see "ci" with "admin"

@v4
Scenario: Show the audit events for a policy
  When I click the link for "ci/jenkins/admin-ui/v1"
  Then I am on the detail page for "ci/jenkins/admin-ui/v1"
  And in the "Audit Events" section I see "created resource ci/jenkins/admin-ui/v1 owned by ci/jenkins/admin-ui/v1"
