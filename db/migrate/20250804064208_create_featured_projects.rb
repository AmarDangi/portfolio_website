class CreateFeaturedProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :featured_projects do |t|
      t.string :title
      t.text :description
      t.text :technologies
      t.string :live_url
      t.string :github_url
      t.boolean :featured
      t.integer :order

      t.timestamps
    end
  end
end
