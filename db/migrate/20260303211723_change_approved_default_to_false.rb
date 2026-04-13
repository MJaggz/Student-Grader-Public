class ChangeApprovedDefaultToFalse < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :approved, from: true, to: false
    change_column_null :users, :approved, true
  end
end
