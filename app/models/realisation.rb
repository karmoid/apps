class Realisation < ActiveRecord::Base
  belongs_to :lifecycle
  has_and_belongs_to_many :techno_instances
  has_and_belongs_to_many :app_modules

  def self.search(search)
    if search
      where(['name like ? or note like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end
  
  rails_admin do
    list do
      field :lifecycle
      field :name
      field :note
      field :techno_instances
      field :app_modules
    end
  end
end
