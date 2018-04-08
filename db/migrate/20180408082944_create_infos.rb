class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :name
      t.text :note
      t.datetime :target

      t.timestamps
    end
  end
end
