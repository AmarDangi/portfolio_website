class CreateStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :statistics do |t|
      t.string :name
      t.string :value
      t.text :description
      t.string :category
      t.integer :order

      t.timestamps
    end
  end
end
