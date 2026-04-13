class CreateGraderRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :grader_requests do |t|
      t.string :request_number
      t.references :section, null: false, foreign_key: true
      t.string :requestor_name
      t.integer :num_graders_requested
      t.boolean :fulfilled

      t.timestamps
    end
  end
end
