class CreateAppRoles < ActiveRecord::Migration
  def change
    create_table :app_roles do |t|
      t.string :name
      t.text :note

      t.timestamps
    end
  end
end
