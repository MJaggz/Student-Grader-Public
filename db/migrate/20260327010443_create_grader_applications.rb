class CreateGraderApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :grader_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :phone_number
      t.string :expected_graduation

      t.timestamps
    end
  end
end
