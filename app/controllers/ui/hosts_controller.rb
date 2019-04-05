class Ui::HostsController < Ui::ConjurObjectController

  def ssh
    find_conjur_object
    hosts = @conjur_object.ssh search_options
    render partial: "ssh", object: hosts
  end

end
