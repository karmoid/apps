class CreateDiscoverySessions < ActiveRecord::Migration
  def change
    create_table :discovery_sessions do |t|
      t.string :name
      t.text :note
      t.datetime :from
      t.datetime :to
      t.integer :newhost
      t.integer :attribute_changes
      t.references :discovery, index: true

      t.timestamps
    end
  end
end
