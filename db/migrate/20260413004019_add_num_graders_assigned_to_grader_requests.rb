class AddNumGradersAssignedToGraderRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :grader_requests, :num_graders_assigned, :integer, default: 0, null: false
  end
end