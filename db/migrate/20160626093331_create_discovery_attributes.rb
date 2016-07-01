class CreateDiscoveryAttributes < ActiveRecord::Migration
  def change
    create_table :discovery_attributes do |t|
      t.string :name
      t.string :value
      t.references :attribute_type, index: true
      t.references :discovery, index: true
      t.references :host, index: true
      t.integer :version

      t.timestamps
    end
  end
end
