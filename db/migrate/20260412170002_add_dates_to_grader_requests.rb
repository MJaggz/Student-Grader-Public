class AddDatesToGraderRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :grader_requests, :request_date, :datetime
    add_column :grader_requests, :fulfilled_date, :datetime
  end
end
