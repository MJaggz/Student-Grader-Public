class AddCreditHoursToSection < ActiveRecord::Migration[8.1]
  def change
    add_column :sections, :creditHours, :string
  end
end
