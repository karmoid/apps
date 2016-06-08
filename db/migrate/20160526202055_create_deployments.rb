class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.string :name
      t.text :note

      t.timestamps
    end
  end
end
