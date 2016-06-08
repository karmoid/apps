class Lifecycle < ActiveRecord::Base
  has_many :realisations

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
    end
  end
end
