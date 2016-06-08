class CreateRealisations < ActiveRecord::Migration
  def change
    create_table :realisations do |t|
      t.text :note
      t.references :techno_instance, index: true
      t.references :app_module, index: true
      t.references :host, index: true
      
      t.timestamps
    end
  end
end
