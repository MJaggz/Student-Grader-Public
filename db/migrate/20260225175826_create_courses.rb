class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :catalog_number
      t.string :subject
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
