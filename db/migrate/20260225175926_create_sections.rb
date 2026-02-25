class CreateSections < ActiveRecord::Migration[8.1]
  def change
    create_table :sections do |t|
      t.references :course, null: false, foreign_key: true
      t.integer :class_number
      t.string :term
      t.string :days
      t.string :times

      t.timestamps
    end
  end
end
