class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :name
      t.text :note
      t.references :maintener, index: true

      t.timestamps
    end

    create_table :app_modules_contracts, id: false do |t|
          t.belongs_to :app_module, index: true
          t.belongs_to :contract, index: true
        end

    create_table :contracts_hosts, id: false do |t|
          t.belongs_to :host, index: true
          t.belongs_to :contract, index: true
    end
  end
end
