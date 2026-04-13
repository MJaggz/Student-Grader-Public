class AddApiFieldsToCourses < ActiveRecord::Migration[8.1]
  def change
    add_column :courses, :term, :string
    add_column :courses, :campus, :string
    add_column :courses, :academic_group, :string
    add_column :courses, :units, :string
    add_column :courses, :academic_career, :string
    add_column :courses, :component, :string
  end
end
