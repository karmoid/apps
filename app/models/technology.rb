class Technology < ActiveRecord::Base
  has_many :techno_instances

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "éléments technologiques"
    else
      "élément technologique"
    end
  end

  rails_admin do
    list do
      field :name
      field :techno_instances
      field :note
    end
  end

end
