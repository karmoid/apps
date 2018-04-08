class Info < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  has_and_belongs_to_many :app_modules
  has_and_belongs_to_many :hosts
  has_and_belongs_to_many :people

  def self.humanize_model(plural)
    if plural
      "informations"
    else
      "information"
    end
  end

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  accepts_nested_attributes_for :people, :allow_destroy => true
  # attr_accessible :people_attributes

  rails_admin do
    list do
      field :name
      field :note
      field :target
      field :app_modules
      field :people
      field :hosts
    end
  end

end
