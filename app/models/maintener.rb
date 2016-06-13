class Maintener < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  has_and_belongs_to_many :people
  has_many :contracts

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "mainteneurs"
    else
      "mainteneur"
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
