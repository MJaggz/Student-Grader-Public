class AddInstructionModeToCourses < ActiveRecord::Migration[8.1]
  def change
    add_column :courses, :instructionMode, :string
  end
end
