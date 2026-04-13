class AddInstructionModeToSections < ActiveRecord::Migration[8.1]
  def change
    add_column :sections, :instructionMode, :string
  end
end
