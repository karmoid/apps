class DiscoveryTool < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  has_many :discoveries

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "outils de découverte"
    else
      "outil de découverte"
    end
  end

end
