# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180408083322) do

  create_table "app_modules", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_modules", ["application_id"], name: "index_app_modules_on_application_id", using: :btree

  create_table "app_modules_contracts", id: false, force: true do |t|
    t.integer "app_module_id"
    t.integer "contract_id"
  end

  add_index "app_modules_contracts", ["app_module_id"], name: "index_app_modules_contracts_on_app_module_id", using: :btree
  add_index "app_modules_contracts", ["contract_id"], name: "index_app_modules_contracts_on_contract_id", using: :btree

  create_table "app_modules_documents", id: false, force: true do |t|
    t.integer "app_module_id"
    t.integer "document_id"
  end

  add_index "app_modules_documents", ["app_module_id"], name: "index_app_modules_documents_on_app_module_id", using: :btree
  add_index "app_modules_documents", ["document_id"], name: "index_app_modules_documents_on_document_id", using: :btree

  create_table "app_modules_infos", id: false, force: true do |t|
    t.integer "info_id",       null: false
    t.integer "app_module_id", null: false
  end

  add_index "app_modules_infos", ["app_module_id"], name: "index_app_modules_infos_on_app_module_id", using: :btree
  add_index "app_modules_infos", ["info_id"], name: "index_app_modules_infos_on_info_id", using: :btree

  create_table "app_modules_powers", id: false, force: true do |t|
    t.integer "app_module_id"
    t.integer "power_id"
  end

  add_index "app_modules_powers", ["app_module_id"], name: "index_app_modules_powers_on_app_module_id", using: :btree
  add_index "app_modules_powers", ["power_id"], name: "index_app_modules_powers_on_power_id", using: :btree

  create_table "app_modules_realisations", id: false, force: true do |t|
    t.integer "realisation_id"
    t.integer "app_module_id"
  end

  add_index "app_modules_realisations", ["app_module_id"], name: "index_app_modules_realisations_on_app_module_id", using: :btree
  add_index "app_modules_realisations", ["realisation_id"], name: "index_app_modules_realisations_on_realisation_id", using: :btree

  create_table "app_roles", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maintener_id"
  end

  add_index "applications", ["maintener_id"], name: "index_applications_on_maintener_id", using: :btree

  create_table "applications_documents", id: false, force: true do |t|
    t.integer "application_id"
    t.integer "document_id"
  end

  add_index "applications_documents", ["application_id"], name: "index_applications_documents_on_application_id", using: :btree
  add_index "applications_documents", ["document_id"], name: "index_applications_documents_on_document_id", using: :btree

  create_table "attribute_types", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contracts", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.integer  "maintener_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contracts", ["maintener_id"], name: "index_contracts_on_maintener_id", using: :btree

  create_table "contracts_hosts", id: false, force: true do |t|
    t.integer "host_id"
    t.integer "contract_id"
  end

  add_index "contracts_hosts", ["contract_id"], name: "index_contracts_hosts_on_contract_id", using: :btree
  add_index "contracts_hosts", ["host_id"], name: "index_contracts_hosts_on_host_id", using: :btree

  create_table "deployments", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discoveries", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.string   "target"
    t.integer  "discovery_tool_id"
    t.string   "credential"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discoveries", ["discovery_tool_id"], name: "index_discoveries_on_discovery_tool_id", using: :btree

  create_table "discovery_attributes", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "attribute_type_id"
    t.integer  "discovery_id"
    t.integer  "host_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "detail"
  end

  add_index "discovery_attributes", ["attribute_type_id"], name: "index_discovery_attributes_on_attribute_type_id", using: :btree
  add_index "discovery_attributes", ["discovery_id"], name: "index_discovery_attributes_on_discovery_id", using: :btree
  add_index "discovery_attributes", ["host_id"], name: "index_discovery_attributes_on_host_id", using: :btree

  create_table "discovery_sessions", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "from"
    t.datetime "to"
    t.integer  "newhost"
    t.integer  "attribute_changes"
    t.integer  "discovery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discovery_sessions", ["discovery_id"], name: "index_discovery_sessions_on_discovery_id", using: :btree

  create_table "discovery_tools", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_types", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.string   "url"
    t.integer  "document_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["document_type_id"], name: "index_documents_on_document_type_id", using: :btree

  create_table "documents_hosts", id: false, force: true do |t|
    t.integer "host_id"
    t.integer "document_id"
  end

  add_index "documents_hosts", ["document_id"], name: "index_documents_hosts_on_document_id", using: :btree
  add_index "documents_hosts", ["host_id"], name: "index_documents_hosts_on_host_id", using: :btree

  create_table "documents_techno_instances", id: false, force: true do |t|
    t.integer "techno_instance_id"
    t.integer "document_id"
  end

  add_index "documents_techno_instances", ["document_id"], name: "index_documents_techno_instances_on_document_id", using: :btree
  add_index "documents_techno_instances", ["techno_instance_id"], name: "index_documents_techno_instances_on_techno_instance_id", using: :btree

  create_table "entities", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entities_people", id: false, force: true do |t|
    t.integer "person_id"
    t.integer "entity_id"
  end

  add_index "entities_people", ["entity_id"], name: "index_entities_people_on_entity_id", using: :btree
  add_index "entities_people", ["person_id"], name: "index_entities_people_on_person_id", using: :btree

  create_table "hosts", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deployment_id"
    t.integer  "host_model_id"
  end

  add_index "hosts", ["deployment_id"], name: "index_hosts_on_deployment_id", using: :btree
  add_index "hosts", ["host_model_id"], name: "index_hosts_on_host_model_id", using: :btree

  create_table "hosts_infos", id: false, force: true do |t|
    t.integer "info_id", null: false
    t.integer "host_id", null: false
  end

  add_index "hosts_infos", ["host_id"], name: "index_hosts_infos_on_host_id", using: :btree
  add_index "hosts_infos", ["info_id"], name: "index_hosts_infos_on_info_id", using: :btree

  create_table "infos", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "target"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infos_people", id: false, force: true do |t|
    t.integer "info_id",   null: false
    t.integer "person_id", null: false
  end

  add_index "infos_people", ["info_id"], name: "index_infos_people_on_info_id", using: :btree
  add_index "infos_people", ["person_id"], name: "index_infos_people_on_person_id", using: :btree

  create_table "lifecycles", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mainteners", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mainteners_people", id: false, force: true do |t|
    t.integer "person_id"
    t.integer "maintener_id"
  end

  add_index "mainteners_people", ["maintener_id"], name: "index_mainteners_people_on_maintener_id", using: :btree
  add_index "mainteners_people", ["person_id"], name: "index_mainteners_people_on_person_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "powers", force: true do |t|
    t.string   "name"
    t.integer  "person_id"
    t.integer  "app_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "powers", ["app_role_id"], name: "index_powers_on_app_role_id", using: :btree
  add_index "powers", ["person_id"], name: "index_powers_on_person_id", using: :btree

  create_table "realisations", force: true do |t|
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "lifecycle_id"
  end

  add_index "realisations", ["lifecycle_id"], name: "index_realisations_on_lifecycle_id", using: :btree

  create_table "realisations_techno_instances", id: false, force: true do |t|
    t.integer "realisation_id"
    t.integer "techno_instance_id"
  end

  add_index "realisations_techno_instances", ["realisation_id"], name: "index_realisations_techno_instances_on_realisation_id", using: :btree
  add_index "realisations_techno_instances", ["techno_instance_id"], name: "index_realisations_techno_instances_on_techno_instance_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "techno_instances", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "host_id"
  end

  add_index "techno_instances", ["host_id"], name: "index_techno_instances_on_host_id", using: :btree
  add_index "techno_instances", ["technology_id"], name: "index_techno_instances_on_technology_id", using: :btree

  create_table "technologies", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
