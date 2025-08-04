class CreateEducations < ActiveRecord::Migration[8.0]
  def change
    create_table :educations do |t|
      t.string :degree
      t.string :institution
      t.text :description
      t.date :start_date
      t.date :end_date
      t.decimal :gpa
      t.boolean :current

      t.timestamps
    end
  end
end
