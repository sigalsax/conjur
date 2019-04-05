@javascript
@policy
Feature: User can search for resources in Conjur UI

  Background: I am logged in
    Given I am logged in as admin

  Scenario: I perform a search through the quick search
    When I query for "prod" through the quick search
    Then I should see all resource boxes checked
    And I should see result count in the header
    And I should see "prod" in the search results
    And I should see pagination

  Scenario: I use filters to refine a quick search
    When I query for "prod" through the quick search
    Then I uncheck "Policy"
    And I should not see "policy" in the search results

  Scenario: I view other pages of search results
    When I query for "prod" through the quick search
    And I should see pagination
    Then I click the pagination link for page "2"
    And I should see page "2" of search results
    Then I click the pagination link for View All
    And I should see all results

  Scenario: I search for a term with code embedded
    When I query for "prod/analytics/v1<script>" through the quick search
    Then I should see "prod/analytics/v1" in the search results
    When I query for "prod/analytics/v1%$#" through the quick search
    Then I should see "prod/analytics/v1" in the search results

  Scenario: I attempt to inject a param into search via the url
      When I query for "[]injected_param=injected_val" through the url
      Then I should see no results
