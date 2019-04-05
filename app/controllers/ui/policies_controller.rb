class Ui::PoliciesController < Ui::ConjurObjectController

  protected

  def find_conjur_object
    @conjur_object = @policy = Policy.new(api.resource([ Conjur.configuration.account, "policy", decoded_id ].join(":")))
    @conjur_role = GenericRole.new(conjur_api.role( @policy.roleid ))
  end
end
