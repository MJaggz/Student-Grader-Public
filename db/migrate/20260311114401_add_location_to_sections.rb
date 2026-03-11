class AddLocationToSections < ActiveRecord::Migration[8.1]
  def change
    add_column :sections, :location, :string
  end
end
