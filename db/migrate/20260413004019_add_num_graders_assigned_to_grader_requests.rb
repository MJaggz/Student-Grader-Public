class AddNumGradersAssignedToGraderRequests < ActiveRecord::Migration[8.1]
  def change
    return if column_exists?(:grader_requests, :num_graders_assigned)

    add_column :grader_requests, :num_graders_assigned, :integer, default: 0, null: false
  end
end
