class RenameColumnsInSections < ActiveRecord::Migration[7.1]
  def change

    rename_column :sections, :creditHours, :credit_hours
    

    rename_column :sections, :instructionMode, :instruction_mode
  end
end