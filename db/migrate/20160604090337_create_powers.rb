class CreatePowers < ActiveRecord::Migration
  def change
    create_table :powers do |t|
      t.string :name
      t.references :person, index: true
      t.references :app_role, index: true

      t.timestamps
    end
  end
end
