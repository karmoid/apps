class CreateDiscoveryTools < ActiveRecord::Migration
  def change
    create_table :discovery_tools do |t|
      t.string :name
      t.text :note

      t.timestamps
    end
  end
end
