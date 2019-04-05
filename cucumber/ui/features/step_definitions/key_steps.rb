When /I lock the appliance keys/ do
  with_master_key do |master_key|
    steps %Q{
      When I successfully run `evoke keys lock`
      And I successfully run `evoke keys encrypt #{master_key}`
    }
  end
end

When /I successfully read a key from the keyring/ do
  with_master_key do |master_key|
    step %Q{I successfully run `evoke keys exec -m #{master_key} -- bash -c 'kr=$(keyctl search @s keyring conjur); keyctl pipe $(keyctl search $kr user authn)'`}
  end

end

When /I read a key from the keyring as the ui user/ do
  with_master_key do |master_key|
    step %Q{I run `evoke keys exec -m #{master_key} -- ./bin/run-as-ui bash -c 'kr=$(keyctl search @s keyring conjur); keyctl pipe $(keyctl search $kr user authn)'`}
  end
end

# Note that evoke keys exec works whether the keys are locked or not.
When /I find SECRET_KEY_BASE in the environment/ do
  dir = File.expand_path('../..', File.dirname(__FILE__))
  with_master_key do |master_key|
    step %{I successfully run `evoke keys exec -m #{master_key} -- bash -xac 'source #{dir}/bin/set-secret-key-base; env | grep "^SECRET_KEY_BASE="'`}
  end
end
