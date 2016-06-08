class CreateMainteners < ActiveRecord::Migration
  def change
    create_table :mainteners do |t|
      t.string :name
      t.text :note

      t.timestamps
    end
  end
end
