class RemoveTermFromCourses < ActiveRecord::Migration[8.1]
  def change
    remove_column :courses, :term, :string
  end
end
