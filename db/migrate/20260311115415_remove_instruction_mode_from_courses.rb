class RemoveInstructionModeFromCourses < ActiveRecord::Migration[8.1]
  def change
    remove_column :courses, :instructionMode, :string
  end
end
