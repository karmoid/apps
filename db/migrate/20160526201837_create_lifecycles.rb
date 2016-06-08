class CreateLifecycles < ActiveRecord::Migration
  def change
    create_table :lifecycles do |t|
      t.string :name
      t.text :note

      t.timestamps
    end
  end
end
