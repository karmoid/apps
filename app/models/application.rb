class Application < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  has_many :app_modules
  belongs_to :maintener
  has_many :powers, through: :app_modules
  has_and_belongs_to_many :documents

  def self.humanize_model(plural)
    if plural
      "applications"
    else
      "application"
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
      field :maintener
      field :app_modules
      field :note
      field :powers
    end
  end
end
