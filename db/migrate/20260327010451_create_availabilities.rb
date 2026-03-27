class CreateAvailabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :availabilities do |t|
      t.references :grader_application, null: false, foreign_key: true
      t.string :day
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
