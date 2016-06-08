class Contract < ActiveRecord::Base
  belongs_to :maintener
  has_and_belongs_to_many :app_modules
  has_and_belongs_to_many :hosts
end
