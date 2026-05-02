class AddUniqueIndexToGraderRequestsSectionId < ActiveRecord::Migration[8.1]
  def up
    existing_index = connection.indexes(:grader_requests).find do |index|
      index.columns == ["section_id"]
    end

    return if existing_index&.unique

    remove_index :grader_requests, :section_id if existing_index
    add_index :grader_requests, :section_id, unique: true
  end

  def down
    remove_index :grader_requests, :section_id if index_exists?(:grader_requests, :section_id, unique: true)
    add_index :grader_requests, :section_id unless index_exists?(:grader_requests, :section_id)
  end
end
