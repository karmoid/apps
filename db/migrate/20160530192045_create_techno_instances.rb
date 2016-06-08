class CreateTechnoInstances < ActiveRecord::Migration
  def change
    create_table :techno_instances do |t|
      t.string :name
      t.text :note
      t.references :technology, index: true

      t.timestamps
    end
  end
end
