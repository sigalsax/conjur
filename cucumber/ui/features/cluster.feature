@policy
Feature: Display cluster status list page in rails

Background: I am logged in
  Given I login as "admin"
  And I visit "/ui/cluster"

Scenario: Show the status information of the Conjur cluster
  And in the "Cluster Health Status" section I see "Master"

Scenario: Shows the correct status for the Master host
  And in the "Services" column of the row containing "Master" I see "Good"
  And in the "Database" column of the row containing "Master" I see "Good"
  And in the "Replication Status" column of the row containing "Master" I see "Good"
  And in the "Free Space" column of the row containing "Master" I see "Good"
