class AddPropertiesToInfos < ActiveRecord::Migration
  def change
	  # This is enough; you don't need to worry about order
	  create_join_table :infos, :people do |t|
	  	t.index :info_id
	  	t.index :person_id
	  end

	  create_join_table :infos, :app_modules do |t|
	  	t.index :info_id
	  	t.index :app_module_id
	  end

	  create_join_table :infos, :hosts do |t|
	  	t.index :info_id
	  	t.index :host_id
	  end
  end
end
