@policy
Feature: Display webservices list and details page in rails

Background: I am logged in
  Given I login as "admin"
  And I visit "/ui/webservices"

Scenario: Show the details page of a webservice
  When I click the link for "prod/analytics/v1"
  Then I am on the detail page for "prod/analytics/v1"
  And in the "Permissions" section I see "prod/analytics/v1" with "delete, get, post, put"

@v4
Scenario: Show the audit events for a webservice
  When I click the link for "prod/analytics/v1"
  Then I am on the detail page for "prod/analytics/v1"
  And in the "Audit Events" section I see "permitted prod/analytics/v1/data-producers to put prod/analytics/v1"
