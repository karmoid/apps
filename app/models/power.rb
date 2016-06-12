class Power < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  belongs_to :person
  belongs_to :app_role
  has_and_belongs_to_many :app_modules

  def self.humanize_model(plural)
    if plural
      "pouvoirs"
    else
      "pouvoir"
    end
  end

end
