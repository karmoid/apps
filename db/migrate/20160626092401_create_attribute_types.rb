class CreateAttributeTypes < ActiveRecord::Migration
  def change
    create_table :attribute_types do |t|
      t.string :name
      t.text :note

      t.timestamps
    end
  end
end
