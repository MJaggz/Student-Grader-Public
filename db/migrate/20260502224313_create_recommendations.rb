class CreateRecommendations < ActiveRecord::Migration[8.1]
  def change
    create_table :recommendations do |t|
      t.string :recommended_by
      t.string :first_name
      t.string :last_name
      t.string :last_name_id
      t.string :course
      t.string :section

      t.timestamps
    end
  end
end
