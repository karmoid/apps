class CreateDiscoveries < ActiveRecord::Migration
  def change
    create_table :discoveries do |t|
      t.string :name
      t.text :note
      t.string :target
      t.references :discovery_tool, index: true
      t.string :credential

      t.timestamps
    end
  end
end
