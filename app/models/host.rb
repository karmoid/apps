class Host < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :os, :hardware_type
  # validates_presence_of :name

  has_many :techno_instances
  belongs_to :deployment
  scope :abstract, -> {includes(:deployment).where(deployments: {name: "abstract"})}
  belongs_to :host_model, -> { abstract },
              class_name: "Host",
              foreign_key: "host_model_id",
              validate: true
  has_many :clones, class_name: "Host", foreign_key: "host_model_id"
  has_many :technologies,  -> { uniq }, through: :techno_instances
  has_and_belongs_to_many :contracts
  has_and_belongs_to_many :documents

  def self.humanize_model(plural)
    if plural
      "hôtes"
    else
      "hôte"
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
    configure :host_model do
      label 'Hôte dérivé de : '
    end
    configure :deployment do
      label 'Type de déploiement : '
    end
    configure :tag_list do
      label 'Mot clés : '
    end
    configure :techno_instances do
      label 'Services hébergés : '
    end
    configure :clones do
      label 'Modèle pour : '
    end
    list do
      field :name
      field :note
      field :techno_instances
      field :deployment
      field :clones
      field :contracts
      field :documents
    end
  end
end
