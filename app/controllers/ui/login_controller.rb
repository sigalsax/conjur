class Ui::LoginController < Ui::ApplicationController
  include BasicAuthenticator
  skip_before_action :authenticate_user!

  layout 'login'

  helper_method :appliance_version

  def new
    renderer.render template: 'login/new'
  end

  def create
    login = params[:login]
    # if login(login[:username], login[:password])
    if authenticate_with_authenticator(login[:username], login[:password])
      redirect_to '/ui'
    else
      redirect_to_login('Incorrect username or password')
    end
  end

  def logout
    reset_session
    redirect_to_login
  end

  private

  def renderer
    ApplicationController.renderer
  end

  def appliance_version
    ClusterStatus.new.health[:version]
  end

  def login(username, password)
    begin
      api_key = Conjur::API.login(username, password)
    rescue RestClient::Unauthorized
      return false
    end
    session[:conjur_username] = username
    session[:conjur_api_key] = api_key
    session[:expires_at] = ApplicationController.expires_at.from_now
    true
  end
end
