class TechnoInstance < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  belongs_to :technology
  belongs_to :host
  has_and_belongs_to_many :realisations
  has_and_belongs_to_many :documents


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
      where(['name like ? or note like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  rails_admin do
    list do
      field :name
      field :technology
      field :host
      field :note
      field :realisations
    end
  end

end
