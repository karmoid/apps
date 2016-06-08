class AddLifeCycleToRealisation < ActiveRecord::Migration
  def change
    add_reference :realisations, :lifecycle, index: true
  end
end
