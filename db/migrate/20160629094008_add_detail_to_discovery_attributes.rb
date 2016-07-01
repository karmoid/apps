class AddDetailToDiscoveryAttributes < ActiveRecord::Migration
  def change
    add_column :discovery_attributes, :detail, :text
  end
end
