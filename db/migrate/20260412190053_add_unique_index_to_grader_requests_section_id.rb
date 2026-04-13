class AddUniqueIndexToGraderRequestsSectionId < ActiveRecord::Migration[8.1]
  def change
    add_index :grader_requests, :section_id, unique: true
  end
end