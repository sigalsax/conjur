# Policy application
def apply_policy(file, namespace=@namespace, role='group:security_admin')
  if Conjur.v5?
    TestPolicies.load_policy_file(file, ns: namespace, owner: 'user:admin')
  else
    Bundler.with_clean_env do
      $stderr.puts `conjur policy load --as-role=#{role} --namespace #{namespace} #{file}`
    end
  end
end

Given(/this policy is in effect:/) do |policy|
  require 'tempfile'
  file = Tempfile.new('policy')
  file.write(policy.strip)
  file.close
  apply_policy file.path
  file.unlink
end
