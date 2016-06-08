class Host < ActiveRecord::Base
  has_many :techno_instances
  belongs_to :deployment
  # has_many :app_modules,  -> { uniq }, through: :techno_instances
  # has_many :techno_instances,  -> { uniq }, through: :realisations
  # has_many :applications,  -> { uniq }, through: :app_modules
  has_many :technologies,  -> { uniq }, through: :techno_instances
  has_and_belongs_to_many :contracts

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
      # field :applications
      # field :app_modules
      field :technologies
      field :techno_instances
      field :note
      field :deployment
    end
  end
end
