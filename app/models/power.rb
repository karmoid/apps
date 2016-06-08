class Power < ActiveRecord::Base
  belongs_to :person
  belongs_to :app_role
  has_and_belongs_to_many :app_modules

end
