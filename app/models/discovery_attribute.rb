class DiscoveryAttribute < ActiveRecord::Base
  belongs_to :attribute_type
  belongs_to :discovery
  belongs_to :host

  scope :updated_between, lambda {|start_date, end_date| where("discovery_attributes.updated_at >= ? AND discovery_attributes.updated_at <= ?", start_date, end_date )}
# DiscoveryAttribute.joins(:discovery, :host, :attribute_type).where(discoveries: {id: d.id}).updated_between(1.hour.ago, Time.now)
  def self.humanize_model(plural)
    if plural
      "Attributs découverts'"
    else
      "Attribut découvert"
    end
  end

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(value) like ? or lower(detail) like ?', "%#{search}%", "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

end
