class Contract < ActiveRecord::Base
  belongs_to :maintener
  has_and_belongs_to_many :app_modules
  has_and_belongs_to_many :hosts

  def self.humanize_model(plural)
    if plural
      "contrats de maintenance"
    else
      "contrat de maintenance"
    end
  end

end
