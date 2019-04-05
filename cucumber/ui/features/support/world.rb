module ConjurUIWorld
  def session
    @session ||= Hash.new
  end

  def login_as login
    api_key = Conjur::API.new_from_authn_local('admin').build_object([account, 'user', login]).rotate_api_key.tap {|key| $stderr.puts "api_key: #{key}" }
    api = Conjur::API.new_from_key login, api_key
    @response = post "/ui/login", login: { username: login, password: api_key }
    page.driver.post "/ui/login", login: { username: login, password: api_key }
    
    Thread.current[:conjur_api] = api
  end

  def logout
    @session = Hash.new

    Thread.current[:conjur_api] = nil
  end

  def conjur_api
    Thread.current[:conjur_api]
  end

  def account
    Conjur.configuration.account
  end

  def new_conjur_object kind, id
    kind.classify.constantize.new(conjur_api.build_object([account,kind,id])).tap do |obj|
      instance_variable_set "@#{kind}", obj
      @last_json = JSON.pretty_generate(obj.as_json)
    end
  end

  def set_json json
    @last_json = json
  end

  def last_json
    @last_json
  end

  def all_users_with_role roleid
    result = Set.new
    roles = [ conjur_api.role(roleid) ]
    while true
      # Get the direct members of each role in the +roles+ set
      # Eliminate roles we've already seen
      # Add the result to the output set
      # Continue if there are any new roles
      members = Set.new(roles.map(&:members).flatten.map(&:member).map(&:roleid)) rescue Set.new
      new_members = members - result
      if new_members.empty?
        break
      else
        result += new_members
        roles = new_members.map{|r| conjur_api.role(r)}
      end
    end
    result.select{|r| r.split(":", 3)[1] == "user"}
  end

  def with_master_key &block
    Tempfile.open('master-key') do |master_key|
      master_key.write('no good very bad key that needs to be long enough')
      master_key.rewind
      yield master_key.path
    end
  end

  def within_section(section)
    within(:xpath, "//div[@class='box'][*/h3[contains(.,'#{section}')]]") do
      yield
    end
  end

  def wait_for_ajax
    return unless respond_to?(:evaluate_script)
    wait_until { finished_all_ajax_requests? }
  end

  def finished_all_ajax_requests?
    evaluate_script('!window.$') || evaluate_script('$.active').zero?
  end

  def wait_until(max_execution_time_in_seconds = Capybara.default_max_wait_time)
    Timeout.timeout(max_execution_time_in_seconds) do
      loop do
        if yield
          return true
        else
          sleep(0.05)
          next
        end
      end
    end
  end

end

World(ConjurUIWorld)
