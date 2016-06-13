class Document < ActiveRecord::Base
  belongs_to :document_type
  has_and_belongs_to_many :hosts
  has_and_belongs_to_many :techno_instances
  has_and_belongs_to_many :applications
  has_and_belongs_to_many :app_modules

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "documents"
    else
      "document"
    end
  end

end
