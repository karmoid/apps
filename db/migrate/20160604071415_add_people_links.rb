class AddPeopleLinks < ActiveRecord::Migration
  def change
    create_table :mainteners_people, id: false do |t|
          t.belongs_to :person, index: true
          t.belongs_to :maintener, index: true
    end

    create_table :entities_people, id: false do |t|
          t.belongs_to :person, index: true
          t.belongs_to :entity, index: true
    end

  end
end
