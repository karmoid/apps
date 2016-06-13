class Realisation < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  belongs_to :lifecycle
  has_and_belongs_to_many :techno_instances
  has_and_belongs_to_many :app_modules

  def self.humanize_model(plural)
    if plural
      "déploiements"
    else
      "déploiement"
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
      field :lifecycle
      field :name
      field :note
      field :techno_instances
      field :app_modules
    end
  end
end
