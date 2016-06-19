class AddHostModelToHost < ActiveRecord::Migration
  def change
    add_reference :hosts, :host_model, index: true
  end
end
