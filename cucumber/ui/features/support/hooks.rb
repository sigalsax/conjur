Before "@namespace" do
  @namespace = SecureRandom.uuid
end

Before "@policy" do
  TestPolicies.load_all
end

Before "@ldap" do
  TestPolicies.load_policies('ldap')
end

Around do |scenario, block|
  ConjurAPI.expose_conjur_api Conjur::API.new_from_authn_local 'admin' do
    block.call
  end
end

module Capybara::Poltergeist
  class Browser
    alias_method :old_command, :command
    def command(name, *args)
      begin
        old_command(name, *args)
      rescue Capybara::Poltergeist::JavascriptError => e
        e.javascript_errors.each { |err|
          raise e unless err.message.downcase.include? 'warning'
          warn err.message
          warn err.stack
        }
      end
    end
  end
end

After do
  if File.exist?('/opt/conjur/etc/authn.key.enc')
    with_master_key do |master_key|
      system("evoke keys decrypt-all #{master_key}") || raise('decrypt-all failed')
    end
  end
end

Before "@javascript" do
  Capybara.send('session_pool').each do |_, session|
    next unless session.driver.is_a?(Capybara::Poltergeist::Driver)
    session.driver.restart
  end
end
