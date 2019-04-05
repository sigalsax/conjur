@v4
Feature: The UI doesn't make the appliance less secure

  Scenario: The ui user can't read the appliance keys
    Given I successfully run `cat /opt/conjur/etc/authn.key`
    When I run `chpst -u ui cat /opt/conjur/etc/authn.key`
    Then the exit status should not be 0
    And the output should contain "Permission denied"

  Scenario: The ui user can't connect to authn-local
    Given I successfully run `bash -c 'echo admin | nc -U /run/authn-local/.socket'`
    When I run `bash -c 'echo admin | chpst -u ui nc -U /run/authn-local/.socket'`
    Then the exit status should not be 0
    And the output should contain "unix connect failed: Permission denied"

  Scenario: The ui user can't access the public schema
    Given I successfully run `bash -c "chpst -u conjur psql conjur -c 'select count(*) from public.resources'"`
    When I run `bash -c "chpst -u ui psql conjur -c 'select count(*) from public.resources'"`
    Then the exit status should not be 0
    And the output should contain "permission denied for schema public"

  Scenario: The ui user can't access the keyring
    Given I lock the appliance keys
    And I successfully read a key from the keyring
    When I read a key from the keyring as the ui user
    Then the exit status should not be 0

  Scenario: SECRET_KEY_BASE gets set from ui.key
    Then I find SECRET_KEY_BASE in the environment

  Scenario: SECRET_KEY_BASE gets set from the keyring
    Given I lock the appliance keys
    Then I find SECRET_KEY_BASE in the environment

    
