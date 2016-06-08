class ChangeRealisation < ActiveRecord::Migration
  def change
    remove_reference :realisations, :app_module, index: true
    remove_reference :realisations, :techno_instance, index: true
  end
end
