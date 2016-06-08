class Application < ActiveRecord::Base
  has_many :app_modules
  belongs_to :maintener
  has_many :powers, through: :app_modules

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
      field :maintener
      field :app_modules
      field :note
      field :powers
    end
  end
end
