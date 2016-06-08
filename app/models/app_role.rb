class AppRole < ActiveRecord::Base
  has_many :powers
  has_many :people, through: :powers

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
