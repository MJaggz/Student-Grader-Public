class AddSectionNumberAndTermUniquenessToSections < ActiveRecord::Migration[8.1]
  def up
    add_column :sections, :section_number, :string

    execute <<~SQL
      UPDATE sections
      SET section_number = CAST(class_number AS TEXT)
      WHERE section_number IS NULL
        AND class_number IS NOT NULL
    SQL

    add_index :sections, [:course_id, :term, :section_number],
      unique: true,
      name: "index_sections_on_course_term_and_section_number"
  end

  def down
    remove_index :sections, name: "index_sections_on_course_term_and_section_number"
    remove_column :sections, :section_number
  end
end
