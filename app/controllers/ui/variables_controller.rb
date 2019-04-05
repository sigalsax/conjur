class VariablesController < Ui::ConjurObjectController

  def show
    @expiration_enabled = expiration_enabled?
  end

  def value
    find_conjur_object
    render :json => {
        value: @variable.get_value
    }
  rescue RestClient::ResourceNotFound => e
    if e.http_body.include? "has expired"
      render status: :not_found, :json => {
          value: "",
          error: "This secret has expired."
      }
    else
      render status: :not_found, :json => {
          value: "",
          error: "This secret has not been initialized."
      }
    end
  rescue RestClient::Unauthorized
    render status: :unauthorized , :json => {
        error: "You are not authorized to perform this action"
    }
  end

  def rotate
    conjur_url = Conjur.configuration.appliance_url
    account = Conjur.configuration.account
    var_name = params['id']
    token = Base64.strict_encode64(api.token.to_json)
    RestClient.post(
      "#{conjur_url}/secrets/#{account}/variable/#{var_name}?expirations",
      '',
      :Authorization => "Token token=\"#{token}\""
    )
  rescue RestClient::Unauthorized
    render status: :unauthorized, :json => {
        error: "You are not authorized to perform this action"
    }
  end

  def edit
    find_conjur_object
    @variable.add_value params[:value]
    render :json => {
        value: params[:value]
    }
  rescue RestClient::Unauthorized
    render status: :unauthorized, :json => {
        error: "You are not authorized to perform this action"
    }
  end

  protected

  def title
    "Secrets"
  end

  def expiration_enabled?
    # The expiration_enabled parameter is only intended for
    # testing. It allows a variable without a rotator to be
    # expired. This functionality isn't useful to the user, so this
    # parameter shouldn't be used in production.
    params[:expiration_enabled] == 'true'
  end

end
