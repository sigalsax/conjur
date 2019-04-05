class Ui::GroupsController < Ui::ConjurObjectController

  protected

  def find_conjur_object
    super

    @editable = @group.editable?
    if @editable
      @available_members = @group.available_resources(%w(layer user group))
    end
  end
end
