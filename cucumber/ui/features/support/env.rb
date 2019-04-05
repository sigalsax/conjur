require 'aruba/cucumber'
require 'cucumber/rails'
require 'json_spec/cucumber'
require 'json_spec/matchers/include_json_subset'

require 'conjur-api'

if File.exist?('/etc/conjur.conf')
  YAML.load_file('/etc/conjur.conf').each do |k,v|
    Conjur.configuration.send(k + '=', v) unless k == 'plugins'
  end
else
  Conjur.configuration.cert_file='/opt/conjur/etc/ssl/conjur.pem'
end

Rails.cache.clear

if Conjur.v5?
  # In v5, we can reset the root policy so all cukes pass, no matter
  # how many times we run them
  Conjur::API::new_from_authn_local('admin')
    .load_policy('root', '[]', method: Conjur::API::POLICY_METHOD_PUT)
end

