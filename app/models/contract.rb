class Contract < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

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
