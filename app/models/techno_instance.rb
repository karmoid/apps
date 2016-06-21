class TechnoInstance < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  # validates_presence_of :name

  belongs_to :technology
  belongs_to :host
  has_and_belongs_to_many :realisations
  has_and_belongs_to_many :documents
  has_many :app_modules, -> { uniq }, through: :realisations
  has_many :applications, -> { uniq }, through: :app_modules


#  has_many :realisations
#  has_many :app_modules,  -> { uniq }, through: :realisations
#  has_many :hosts,  -> { uniq }, through: :realisations

  def self.humanize_model(plural)
    if plural
      "instances"
    else
      "instance"
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
    configure :name do
      label 'Nom : '
    end
    configure :note do
      label 'Note/Description : '
    end
    configure :host do
      label 'Hôte : '
    end
    configure :technology do
      label 'Type de service : '
    end
    configure :tag_list do
      label 'Mot clés : '
    end
    configure :realisations do
      label 'Déploiement de services : '
    end
    configure :documents do
      label 'Ressources documentaires : '
    end

    list do
      field :name
      field :note
      field :technology
      field :host
      field :realisations
      filed :documents
    end
  end

end
