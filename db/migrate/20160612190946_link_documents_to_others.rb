class LinkDocumentsToOthers < ActiveRecord::Migration
  def change
    create_table :app_modules_documents, id: false do |t|
          t.belongs_to :app_module, index: true
          t.belongs_to :document, index: true
        end

    create_table :applications_documents, id: false do |t|
          t.belongs_to :application, index: true
          t.belongs_to :document, index: true
    end

    create_table :documents_hosts, id: false do |t|
          t.belongs_to :host, index: true
          t.belongs_to :document, index: true
    end

    create_table :documents_techno_instances, id: false do |t|
          t.belongs_to :techno_instance, index: true
          t.belongs_to :document, index: true
    end

  end
end
