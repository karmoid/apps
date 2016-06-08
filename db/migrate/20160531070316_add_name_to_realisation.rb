class AddNameToRealisation < ActiveRecord::Migration
  def change
    add_column :realisations, :name, :string
  end
end
