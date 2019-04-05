require 'conjur-api'

module TestPolicies
  extend self
  def load_all(api = Conjur::API.new_from_authn_local('admin'))
    already_loaded = api.resource('cucumber:group:operations').exists?
    if !already_loaded || ENV['RELOAD_POLICIES']
      %w(groups users conjur).each { |g| load_policies g }
      adjust_user_permissions
      load_policies('ci/*', ns: 'ci', owner: 'policy:ci')
      load_policies('prod/*', ns: 'prod', owner: 'policy:prod')
      %w(hosts entitlements).each { |g| load_policies g}
      load_policies 'ssh-entitlements' if Conjur.v4?
    end
  end

  def load_policies(glob, ns: nil, owner: nil)
    dir = File.expand_path('policy', File.dirname(__FILE__))
    Dir.chdir dir do
      find_policies(glob).each do |f|
        begin
          load_policy_file f, ns: ns, owner: owner
        rescue RestClient::RequestFailed => ex
          puts ex.response.to_s
          raise
        end
      end
    end
  end

  def find_policies(glob)
    Dir.glob(glob + '.yml').tap do |files|
      raise "No files matched #{glob}" unless files.size > 0
    end
  end

  if Conjur.v5?
    def load_policy_file(file, ns:, owner:)
      policy = File.read(file)
     $stderr.puts "Loading policies from #{file}"
      if ns && owner
        kind,id = owner.split(':', 2)
        policy = """
- !policy
  id: #{ns}
  owner: !#{kind} #{id}
  body:
#{policy.indent(4)}
"""
      end
      load_policy(policy)
    end

    def load_policy(policy)
      Conjur::API::new_from_authn_local('admin')
        .load_policy('root', policy)
    rescue RestClient::Exception => ex
      $stderr.puts "Failed loading policy: #{JSON.parse(ex.http_body)['error']['message']}"
      raise
    end

    def adjust_user_permissions
      policy = ''
      Conjur::API.new_from_authn_local('admin').resources(kind: 'user').collect do |u|
        policy << """
- !permit
  resource: !user #{u.identifier}
  privilege: read
  role: !user #{u.identifier}
"""
      end
      load_policy(policy)
    end
  else
    def load_policy_file(file, ns: nil, owner: nil)
      $stderr.puts "Loading policy file #{file}"
      ns_arg = "--namespace #{ns}" if ns
      owner_arg = "--as-role #{owner}" if owner
      Bundler.with_clean_env do
        %x(conjur elevate policy load #{ns_arg} #{owner_arg} #{file})
      end
    end

    def adjust_user_permissions
      # nothing to do for v4
    end
  end
end
