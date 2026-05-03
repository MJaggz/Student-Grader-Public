class AddStatusToRecommendations < ActiveRecord::Migration[8.1]
  def change
    add_column :recommendations, :status, :boolean, default: false, null: false
  end
end
