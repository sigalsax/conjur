@namespace
Feature: Display Variables list and details page in rails

Background: I am logged in
  Given this policy is in effect:
"""
- !variable
  id: password
  annotations:
    mime_type: text/plain
    my_annotation: a value

- !user alice

- !permit
  role: !user alice
  privilege: [read, execute]
  resource: !variable password
"""
  And I am logged in as admin
  And I visit "/ui/secrets"

@javascript
Scenario: Show the details page of a Variable
  And I click the link for "password" in this namespace
  Then I am on the detail page for "password"
  And the page should not contain the selector "#variable-expired-alert"
  And the page should not contain the selector "#rotate-secret-value"
  And in the "Resource Permissions" section I see "alice"
  And in the "Details" section I see "a value"

@v4
Scenario: The details page shows the audit events for a variable
  When I click the link for "password" in this namespace
  Then I am on the detail page for "password"
  And in the "Warnings" section I see "There are no warnings available"
  And in the "Updates" section I see "updated annotation my_annotation"
  And in the "Activity" section I see an element matching "#activity-graph svg"

@javascript
Scenario: Read and update variable on details page
  And I click the link for "password" in this namespace
  Then I am on the detail page for "password"
  And in the "Secret Manager" section I see "View/Edit Secret Data"
  Then I click "View/Edit Secret Data"
  And in the "Secret Manager" section I see "Hide Secret Data"
  And I see that the secret-value has finished loading
  And in the "Secret Manager" section I see "This secret has not been initialized."
  Then I update the secret value to "a new secret value"
  And I visit "/ui/secrets"
  And I click the link for "password" in this namespace
  Then I click "View/Edit Secret Data"
  And I see that the secret-value has finished loading
  And in the "Secret Manager" section I see "a new secret value"
  Then I click "Hide Secret Data"
  And in the "Secret Manager" section I see "View/Edit Secret Data"


@v4
@javascript
Scenario: Rotate now button is visible on details page for variable with rotator
  Given this policy is in effect:
"""
- !variable
  id: password-with-rotator
  annotations:
    mime_type: text/plain
    my_annotation: a value
    rotation/rotator: nop
    rotation/ttl: P1D
"""
  And I visit the page for the variable "password-with-rotator" in this namespace
  Then I am on the detail page for "password-with-rotator"
  And in the "Secret Manager" section I see "Rotate now"
  And the page should not contain the selector "#variable-expired-alert"
  And I click the "Rotate now" button
  And the page should contain the selector "#variable-expired-alert"
  And I click on selector "#variable-expired-alert .close"
  And the page should not contain the selector "#variable-expired-alert"
  Then I click "View/Edit Secret Data"
  And in the "Secret Manager" section I see "Hide Secret Data"
  And I see that the secret-value has finished loading
  Then I reload until successful rotation shows up in audit logs
  And the page should not contain the selector "#variable-expired-alert"

@v4
@javascript
Scenario: An expired variable shows the correct message
  Given this policy is in effect:
"""
- !variable
  id: password-with-rotator
  annotations:
    mime_type: text/plain
    my_annotation: a value
"""
  And I visit the page for the variable "password-with-rotator" in this namespace with expiration enabled
  And I click the "Rotate now" button
  Then I click "View/Edit Secret Data"
  And I see that the secret-value has finished loading
  And in the "Secret Manager" section I see "This secret has expired."
