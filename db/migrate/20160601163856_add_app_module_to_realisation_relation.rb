class AddAppModuleToRealisationRelation < ActiveRecord::Migration
  def change
    create_table :app_modules_realisations, id: false do |t|
          t.belongs_to :realisation, index: true
          t.belongs_to :app_module, index: true
    end    
  end
end
