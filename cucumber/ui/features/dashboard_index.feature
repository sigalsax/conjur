Feature: Display interactive components on dashboard index page in rails

Background: I am logged in
  When I am logged in as admin
  And I visit "/ui/dashboard"

@v4
@javascript
Scenario: Show Most Active Secrets
  Then I see label and horizontal bar graph of most active secrets

@javascript
Scenario: Audit entry tables are present
  Then the page should contain the selector "#dashboard-warnings-table"
  And the page should contain the selector "#dashboard-changes-table"
  And the page should contain the selector "#dashboard-activity-table"
