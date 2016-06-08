class AddMaintenerToApplication < ActiveRecord::Migration
  def change
    add_reference :applications, :maintener, index: true
  end
end
