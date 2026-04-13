class CreateCoursePreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :course_preferences do |t|
      t.references :grader_application, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
