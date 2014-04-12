class CreateFriendlyIdSlugs < ActiveRecord::Migration
  def change
    create_table "friendly_id_slugs", force: true do |t|
      t.string   "slug",                      null: false
      t.integer  "sluggable_id",              null: false
      t.string   "sluggable_type", limit: 50
      t.string   "scope"
      t.datetime "created_at"
    end

    add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end
end
