class UpdateGraderRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :grader_requests, :num_graders_assigned, :integer, null: false, default: 0
    remove_column :grader_requests, :fulfilled, :boolean
    add_index :grader_requests, :request_number, unique: true
  end
end