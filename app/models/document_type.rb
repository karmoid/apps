class DocumentType < ActiveRecord::Base
  has_many :documents

  def self.search(search)
    if search
      where(['lower(name) like ? or lower(note) like ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  def self.humanize_model(plural)
    if plural
      "types de document"
    else
      "type de document"
    end
  end

end
