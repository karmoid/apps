class Technology < ActiveRecord::Base
  has_many :techno_instances

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
      field :techno_instances
      field :note
    end
  end

end
