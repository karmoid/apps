class Entity < ActiveRecord::Base
  has_and_belongs_to_many :people

  def self.search(search)
    if search
      where(['name like ? or note like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end
  
  rails_admin do
    list do
      field :name
      field :note
      field :people
    end
  end

end
