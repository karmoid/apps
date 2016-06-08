class RemoveHostFromRealisation < ActiveRecord::Migration
  def change
    remove_reference :realisations, :host, index: true
  end
end
