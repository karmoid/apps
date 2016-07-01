class AttributeType < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  has_many :discovery_attributes

  def self.humanize_model(plural)
    if plural
      "types d'attribut'"
    else
      "type d'attribut"
    end
  end

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

end
