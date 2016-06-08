class Maintener < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_many :contracts

  def self.search(search)
    if search
      where(['name like ? or note like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  has_many :applications
  rails_admin do
    list do
      field :name
      field :note
      field :applications
      field :people
    end
  end
end
