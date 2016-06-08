class AddAppModulePowerRelation < ActiveRecord::Migration
  def change
    create_table :app_modules_powers, id: false do |t|
          t.belongs_to :app_module, index: true
          t.belongs_to :power, index: true
    end
  end
end
