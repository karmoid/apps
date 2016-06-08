class AddRealisationTechnoInstanceRelation < ActiveRecord::Migration
  def change
    create_table :realisations_techno_instances, id: false do |t|
          t.belongs_to :realisation, index: true
          t.belongs_to :techno_instance, index: true
    end
  end
end
