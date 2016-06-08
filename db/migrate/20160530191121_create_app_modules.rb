class CreateAppModules < ActiveRecord::Migration
  def change
    create_table :app_modules do |t|
      t.string :name
      t.text :note
      t.references :application, index: true

      t.timestamps
    end
  end
end
