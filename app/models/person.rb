class Person < ActiveRecord::Base
  has_and_belongs_to_many :entities
  has_and_belongs_to_many :mainteners
  has_many :powers

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
      field :entities
      field :mainteners
    end
  end
end
