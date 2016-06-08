class AddHostToTechnoInstance < ActiveRecord::Migration
  def change
    add_reference :techno_instances, :host, index: true
  end
end
