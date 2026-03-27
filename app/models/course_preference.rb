class CoursePreference < ApplicationRecord
  belongs_to :grader_application
  belongs_to :course
end
