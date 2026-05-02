class CreateGraderAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :grader_assignments, if_not_exists: true do |t|
      t.references :section, null: false, foreign_key: true
      t.references :grader_application, null: false, foreign_key: true
      t.datetime :assigned_at

      t.timestamps
    end

    add_index :grader_assignments,
              [:section_id, :grader_application_id],
              unique: true,
              if_not_exists: true
  end
end
