class Deployment < ActiveRecord::Base
  has_many :hosts

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "types de déploiement"
    else
      "type de déploiement"
    end
  end

  rails_admin do
    list do
      field :name
      field :note
      field :hosts
    end
  end
end
