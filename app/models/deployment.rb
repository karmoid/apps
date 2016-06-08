class Deployment < ActiveRecord::Base
  has_many :hosts

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
      field :hosts
    end
  end
end
