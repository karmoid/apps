class AppModule < ActiveRecord::Base
  belongs_to :application
  # has_many :realisations
  # has_many :techno_instances,  -> { uniq }, through: :realisations
  # has_many :hosts,  -> { uniq }, through: :realisations
  has_and_belongs_to_many :realisations
  has_and_belongs_to_many :powers
  has_many :people,  -> { uniq }, through: :powers
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
      field :application
      field :name
      field :realisations
      field :note
      field :people
    end
  end

end
