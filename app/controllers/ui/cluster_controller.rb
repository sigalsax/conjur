class Ui::ClusterController < Ui::ApplicationController

  def list
    @health = ClusterStatus.new.health
  end

end
