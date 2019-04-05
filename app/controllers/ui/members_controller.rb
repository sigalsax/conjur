class Ui::MembersController < Ui::ApplicationController

  before_action :verify_editable
  before_action :set_scroll_to

  def create
    api.role(params[:role_id]).grant_to(params[:member_id], admin_option: params[:admin_option].present?)
    flash[:notice] = generate_create_message(params[:role_id], params[:member_id])
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { head :no_content } # only for testing, the UI doesn't ask for a JSON response
    end
  end

  def destroy
    api.role(params[:role_id]).revoke_from(params[:id])
    flash[:notice] = generate_destroy_message(params[:role_id], params[:id])
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { head :no_content } # only for testing
    end
  end

  private

  def verify_editable
    resource = ResourceIdentifier.new(params[:role_id])

    unless resource.kind.titleize.constantize.new(api.resource(resource.full_resource_identifier)).editable?
      redirect_to request.referrer
      false
    end
  end

  def set_scroll_to
    flash[:scroll_to] = params[:scroll_to] if params.key?(:scroll_to)
  end

  def generate_create_message(role_id, member_id)
    role = load_resource(role_id)
    member = load_resource(member_id)
    "Successfully added #{member.kind} #{member.id} to the #{role.id} #{role.kind}"
  end

  def generate_destroy_message(role_id, member_id)
    role = load_resource(role_id)
    member = load_resource(member_id)
    "Successfully removed #{member.kind} #{member.id} from the #{role.id} #{role.kind}"
  end

  def load_resource(id)
    GenericResource.new(conjur_api.resource(id))
  end
end
