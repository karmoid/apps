class AddDeploymentToHost < ActiveRecord::Migration
  def change
    add_reference :hosts, :deployment, index: true
  end
end
