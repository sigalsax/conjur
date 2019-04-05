@policy
Feature: Display groups list and details page in rails

Background: I am logged in
  Given I login as "admin"
  And I visit "/ui/groups"

Scenario: Show the details page of a group
  And I click the link for "ci-admin"
  Then I am on the detail page for "ci-admin"
  And in the "Permissions" section I see "ci" with "admin"

Scenario: Show the memberships of a group
  And I click the link for "analytics-team"
  Then I am on the detail page for "analytics-team"
  And in the "Group Memberships" subsection I see "employees"

@v4
Scenario: Permissions granted through layer membership are shown
  And I click the link for "ci-admin"
  Then I am on the detail page for "ci-admin"
  And in the "Permissions" section I see "ci/jenkins/v1/executors" with "executor-centos-01.itci.myorg.com"

@v4
Scenario: Show the audit events for a group
  And I click the link for "ci-admin"
  Then I am on the detail page for "ci-admin"
  And in the "Audit Events" section I see "granted role ci to ci-admin with admin option"
