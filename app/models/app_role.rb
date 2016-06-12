class AppRole < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  has_many :powers
  has_many :people, through: :powers

  def self.search(search)
    if search
      where(['name like ? or note like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "rôles"
    else
      "rôle"
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
