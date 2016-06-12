class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.text :note
      t.string :url
      t.references :document_type, index: true

      t.timestamps
    end
  end
end
