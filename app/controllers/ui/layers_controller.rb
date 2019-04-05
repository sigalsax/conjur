class Ui::LayersController < Ui::ConjurObjectController

  def add_token
    find_layer

    @layer.generate_new_token
    render partial: 'tokens', object: @layer.tokens
  end

  def remove_token
    find_layer

    @layer.remove_token(params[:token_value])
    render partial: 'tokens', object: @layer.tokens
  end

  protected

  def find_conjur_object
    super

    @editable = @layer.editable?
    if @editable
      @available_hosts = @layer.available_resources(%w(host))
    end

  end

  def find_layer
    @layer = Layer.new(api.resource([Conjur.configuration.account, 'layer', decoded_id].join(':')))
  end
end
