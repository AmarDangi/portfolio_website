class CreateExperiences < ActiveRecord::Migration[8.0]
  def change
    create_table :experiences do |t|
      t.string :title
      t.string :company
      t.date :start_date
      t.date :end_date
      t.boolean :current
      t.text :description
      t.integer :order

      t.timestamps
    end
  end
end
