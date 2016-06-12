class AppModule < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  belongs_to :application
  # has_many :realisations
  # has_many :techno_instances,  -> { uniq }, through: :realisations
  # has_many :hosts,  -> { uniq }, through: :realisations
  has_and_belongs_to_many :realisations
  has_and_belongs_to_many :powers
  has_many :people,  -> { uniq }, through: :powers
  has_and_belongs_to_many :contracts
  has_and_belongs_to_many :documents

  def self.humanize_model(plural)
    if plural
      "modules applicatifs"
    else
      "module applicatif"
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
      field :application
      field :name
      field :realisations
      field :note
      field :people
    end
  end

end
