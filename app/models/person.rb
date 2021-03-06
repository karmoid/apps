class Person < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  has_and_belongs_to_many :entities
  has_and_belongs_to_many :mainteners
  has_many :powers
  has_and_belongs_to_many :infos


  def self.humanize_model(plural)
    if plural
      "contacts"
    else
      "contact"
    end
  end

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
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
      field :infos
    end
  end
end
