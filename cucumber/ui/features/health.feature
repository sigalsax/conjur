Feature: The service supports health checking

  Scenario: the service is healthy
    When I do a health check
    Then the response status is 200
